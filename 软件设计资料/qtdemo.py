import sys
import socket
import cv2
import io
from PIL import Image
import numpy as np
from PySide2.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QHBoxLayout, QPushButton, QLabel, QWidget
from PySide2.QtGui import QImage, QPixmap
from PySide2.QtCore import Qt, QThread, Signal, QTimer
import time
class VideoStreamWorker(QThread):
    new_frame = Signal(np.ndarray)

    def __init__(self, url):
        super().__init__()
        self.url = url
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, 0)
        self.socket.bind(("0.0.0.0", 9090))
        self.running = False
        self.frame_count = 0
        self.start_time = 0

    def run(self):
        self.running = True
        while self.running:
            data, IP = self.socket.recvfrom(100000)
            bytes_stream = io.BytesIO(data)
            image = Image.open(bytes_stream)
            img = np.asarray(image)
            img = cv2.cvtColor(img, cv2.COLOR_RGB2BGR)  # ESP32 captures in RGB format, convert to BGR for OpenCV
            self.new_frame.emit(img)
            self.frame_count += 1
            if self.frame_count == 1:
                self.start_time = time.time()

    def stop(self):
        self.running = False

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.video_url = 'http://192.168.43.103/cam-hi.jpg'  # Change to your ESP32-CAM IP address + /cam-hi.jpg
        self.video_worker = VideoStreamWorker(self.video_url)
        self.video_worker.new_frame.connect(self.update_frame)

        self.start_button = QPushButton('开始')
        self.start_button.clicked.connect(self.start_video)

        self.stop_button = QPushButton('停止')
        self.stop_button.clicked.connect(self.stop_video)

        self.video_label = QLabel()
        self.video_label.setAlignment(Qt.AlignCenter)
        self.video_label.setStyleSheet("QLabel { background-color: black; border: 1px solid gray; }")
        self.video_label.setFixedSize(640, 480)  # Set a fixed size for the video display

        self.fps_label = QLabel('FPS: 0')

        self.robot_control_button = QPushButton('机器人控制')
        self.sit_reminder_button = QPushButton('久坐提醒')
        self.voice_button = QPushButton('语音')

        layout = QVBoxLayout()
        layout.addWidget(self.video_label)
        layout.addWidget(self.fps_label)

        buttons_layout = QHBoxLayout()
        buttons_layout.addWidget(self.start_button)
        buttons_layout.addWidget(self.stop_button)

        layout.addLayout(buttons_layout)

        # Add the switches to the layout on the right side
        switches_layout = QVBoxLayout()
        switches_layout.addWidget(self.robot_control_button)
        switches_layout.addWidget(self.sit_reminder_button)
        switches_layout.addWidget(self.voice_button)

        buttons_layout.addLayout(switches_layout)

        container = QWidget()
        container.setLayout(layout)
        self.setCentralWidget(container)

        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_fps)
        self.timer.start(1000)  # Update FPS every 1000 ms (1 second)

    def start_video(self):
        self.video_worker.start()

    def stop_video(self):
        self.video_worker.stop()

    def update_frame(self, frame):
        # Convert the BGR frame to RGB for displaying with PySide2
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        # Resize the frame to fit the label
        h, w, _ = frame.shape
        aspect_ratio = w / h
        label_width = self.video_label.width()
        label_height = int(label_width / aspect_ratio)

        resized_frame = cv2.resize(frame, (label_width, label_height))
        qt_img = self.convert_cv_to_qt(resized_frame)
        self.video_label.setPixmap(qt_img)

    def update_fps(self):
        elapsed_time = time.time() - self.video_worker.start_time
        fps = self.video_worker.frame_count / elapsed_time if elapsed_time > 0 else 0
        self.fps_label.setText(f'FPS: {fps:.2f}')

    def convert_cv_to_qt(self, cv_img):
        height, width, channel = cv_img.shape
        bytes_per_line = 3 * width
        qt_img = QImage(cv_img.data, width, height, bytes_per_line, QImage.Format_RGB888)
        return QPixmap.fromImage(qt_img)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    mainWindow = MainWindow()
    mainWindow.setWindowTitle('吃一顿好的机器人')

    # Apply some styles to make the GUI look better
    mainWindow.setStyleSheet("QMainWindow { background-color: #F0F0F0; }"
                             "QPushButton { padding: 10px; font-size: 16px; border: 1px solid #555; border-radius: 5px; }"
                             "QPushButton:hover { background-color: #555; color: white; }")

    mainWindow.show()
    sys.exit(app.exec_())
