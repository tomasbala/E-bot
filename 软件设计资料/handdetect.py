import cv2
import mediapipe as mp
import time
import math


# 根据手指四个关节判断手指是否伸直
def get_angleError(point_4,point_3,point_2,point_1):
    try:
        point_4_cx, point_4_cy = int(point_4.x * w), int(point_4.y * h)
        point_3_cx, point_3_cy = int(point_3.x * w), int(point_3.y * h)
        point_2_cx, point_2_cy = int(point_2.x * w), int(point_2.y * h)
        point_1_cx, point_1_cy = int(point_1.x * w), int(point_1.y * h)

        angle_1 = math.degrees(math.atan((point_3_cx - point_4_cx) / (point_3_cy - point_4_cy)))
        angle_2 = math.degrees(math.atan((point_1_cx - point_2_cx) / (point_1_cy - point_2_cy)))
        angle_error = abs(angle_1 - angle_2)
        if angle_error<12:
            isStraight = 1
        else:
            isStraight = 0
    except:
        angle_error = 1000
        isStraight = 0

    return angle_error, isStraight


# 根据五根手指伸直程度识别手势
def getGesture(isStraight_list):
    if isStraight_list[0]==0 and isStraight_list[1]==1 and isStraight_list[2]==0 and isStraight_list[3]==0 and isStraight_list[4]==0:
        gesture = "one"
    elif isStraight_list[0]==0 and isStraight_list[1]==1 and isStraight_list[2]==1 and isStraight_list[3]==0 and isStraight_list[4]==0:
        gesture = "two"
    elif isStraight_list[0]==0 and isStraight_list[1]==0 and isStraight_list[2]==1 and isStraight_list[3]==1 and isStraight_list[4]==1:
        gesture = "three"
    elif isStraight_list[0]==0 and isStraight_list[1]==1 and isStraight_list[2]==1 and isStraight_list[3]==1 and isStraight_list[4]==1:
        gesture = "four"
    elif isStraight_list[0]==1 and isStraight_list[1]==1 and isStraight_list[2]==1 and isStraight_list[3]==1 and isStraight_list[4]==1:
        gesture = "five"
    else:
        gesture = "None"

    return gesture

cap = cv2.VideoCapture(0)
mpHands = mp.solutions.hands
hands = mpHands.Hands(static_image_mode=False,
                      max_num_hands=2,
                      min_detection_confidence=0.5,
                      min_tracking_confidence=0.5)

mpDraw = mp.solutions.drawing_utils
pTime = 0
cTime = 0
while True:
    success, img = cap.read()
    img = cv2.flip(img, 1)
    imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    results = hands.process(imgRGB)
    #print(results.multi_hand_landmarks)
    if results.multi_hand_landmarks:

        for handLms in results.multi_hand_landmarks:
            for id, lm in enumerate(handLms.landmark):
                #print(id,lm)
                h, w, c = img.shape
                cx, cy = int(lm.x *w), int(lm.y*h)
                # print(cx,cy)
                #if id ==0:
                cv2.circle(img, (cx,cy), 3, (255,0,255), cv2.FILLED)
            mpDraw.draw_landmarks(img, handLms, mpHands.HAND_CONNECTIONS)

        # 判断拇指手势方向：
        isStraight_list = []
        point_4 = handLms.landmark[4]
        point_3 = handLms.landmark[3]
        point_2 = handLms.landmark[2]
        point_1 = handLms.landmark[1]
        angle_error_1, isStraight_1 = get_angleError(point_4,point_3,point_2,point_1)
        print("isStraight_1:",isStraight_1)
        isStraight_list.append(isStraight_1)

        # 判断食指手势方向：
        point_4 = handLms.landmark[8]
        point_3 = handLms.landmark[7]
        point_2 = handLms.landmark[6]
        point_1 = handLms.landmark[5]
        angle_error_2, isStraight_2 = get_angleError(point_4,point_3,point_2,point_1)
        print("isStraight_2:",isStraight_2)
        isStraight_list.append(isStraight_2)

        # 判断中指手势方向：
        point_4 = handLms.landmark[12]
        point_3 = handLms.landmark[11]
        point_2 = handLms.landmark[10]
        point_1 = handLms.landmark[9]
        angle_error_3, isStraight_3 = get_angleError(point_4,point_3,point_2,point_1)
        print("isStraight_3:",isStraight_3)
        isStraight_list.append(isStraight_3)

        # 判断无名指手势方向：
        point_4 = handLms.landmark[16]
        point_3 = handLms.landmark[15]
        point_2 = handLms.landmark[14]
        point_1 = handLms.landmark[13]
        angle_error_4, isStraight_4 = get_angleError(point_4,point_3,point_2,point_1)
        print("isStraight_4:",isStraight_4)
        isStraight_list.append(isStraight_4)

        # 判断小指手势方向：
        point_4 = handLms.landmark[20]
        point_3 = handLms.landmark[19]
        point_2 = handLms.landmark[18]
        point_1 = handLms.landmark[17]
        angle_error_5, isStraight_5 = get_angleError(point_4,point_3,point_2,point_1)
        print("isStraight_5:",isStraight_5)
        isStraight_list.append(isStraight_5)

        # 根据五根手指的伸直程度判断手势所对应的数字
        gesture  = getGesture(isStraight_list)
        print("gesture:",gesture)

        cv2.putText(img, gesture, (10, 100), cv2.FONT_HERSHEY_PLAIN, 3, (255, 0, 255), 3)


    cTime = time.time()
    fps = 1/(cTime-pTime)
    pTime = cTime
    # cv2.putText(img,str(int(fps)), (10,70), cv2.FONT_HERSHEY_PLAIN, 3, (255,0,255), 3)
    cv2.imshow("Image", img)
    cv2.waitKey(1)
