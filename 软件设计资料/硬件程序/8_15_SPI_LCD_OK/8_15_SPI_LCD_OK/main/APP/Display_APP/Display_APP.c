#include "Display_APP.h"

#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_timer.h"
#include "esp_lcd_panel_io.h"
#include "esp_lcd_panel_vendor.h"
#include "esp_lcd_panel_ops.h"
#include "driver/gpio.h"
#include "driver/spi_master.h"
#include "esp_err.h"
#include "esp_log.h"
#include "lvgl.h"
#include "esp_lcd_gc9a01.h"

#include "lvgl_test_demo/lvgl_test_demo.h"

static const char *TAG = "Display_APP";

/* 使用 SPI2 */
#define LCD_HOST  SPI2_HOST

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////// Please update the following configuration according to your LCD spec //////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define LCD_PIXEL_CLOCK_HZ     (20 * 1000 * 1000)                //LCD像素时钟
#define LCD_BK_LIGHT_ON_LEVEL  1                                 //LCD背光控制打开时的电平
#define LCD_BK_LIGHT_OFF_LEVEL !EXAMPLE_LCD_BK_LIGHT_ON_LEVEL    //LCD背光控制关闭时的电平
#define LCD_PIN_NUM_SCLK           12                            //LCD_SCLK使用的引脚
#define LCD_PIN_NUM_MOSI           11                            //LCD_MOSI使用的引脚
#define LCD_PIN_NUM_MISO           13                            //LCD_MISO使用的引脚
#define LCD_PIN_NUM_LCD_DC         9                             //LCD_DC使用的引脚
#define LCD_PIN_NUM_LCD_RST        -1
#define LCD_PIN_NUM_LCD_CS         10                            //LCD_CS使用的引脚
#define LCD_PIN_NUM_BK_LIGHT       46                            //LCD背光控制使用的引脚

/* 水平和垂直的像素数 */
#define LCD_H_RES         240       //水平像素数 
#define LCD_V_RES         240       //垂直像素数 

/* 用于表示命令和参数的位宽 */
#define LCD_CMD_BITS           8    //命令位宽
#define LCD_PARAM_BITS         8    //参数位宽

/* LVGL的时钟 */
#define LVGL_TICK_PERIOD_MS    1


/************************ 函数声明 *********************************/
/* 缓冲区数据传输完成后，准备对屏幕进行刷新 */
static bool Notify_lvgl_flush_ready(esp_lcd_panel_io_handle_t panel_io, esp_lcd_panel_io_event_data_t *edata, void *user_ctx);

/* 将缓冲区内的数据写入到显示器进行显示 */
static void lvgl_flush_cb(lv_disp_drv_t *drv, const lv_area_t *area, lv_color_t *color_map);

/* 当屏幕驱动程序参数更新时调用的函数 */ 
static void lvgl_drv_update_callback(lv_disp_drv_t *drv);

/* LVGL使用的滴答定时器回调函数 */
static void lvgl_timer_tick(void *arg);

void Display_APP_Task(void *arg)
{
    static lv_disp_draw_buf_t disp_buf; // 保存显示缓冲区信息的结构体
    static lv_disp_drv_t disp_drv;      // 注册的驱动程序结构体，包含回调函数

    /* 配置LCD背光控制引脚 */
    ESP_LOGI(TAG, "配置LCD背光控制引脚");
    gpio_config_t bk_gpio_config = {
        .mode = GPIO_MODE_OUTPUT,
        .pin_bit_mask = 1ULL << LCD_PIN_NUM_BK_LIGHT
    };
    ESP_ERROR_CHECK(gpio_config(&bk_gpio_config));  // 背光控制引脚初始化 

    /* 配置SPI总线 */
    spi_bus_config_t buscfg = {                
        .sclk_io_num = LCD_PIN_NUM_SCLK,
        .mosi_io_num = LCD_PIN_NUM_MOSI,
        .miso_io_num = LCD_PIN_NUM_MISO,
        .max_transfer_sz = LCD_H_RES * 80 * sizeof(uint16_t),  // 最大传输大小（以字节为单位）。
    };
    ESP_ERROR_CHECK(spi_bus_initialize(LCD_HOST, &buscfg, SPI_DMA_CH_AUTO));      //初始化SPI总线

    /* 配置屏幕相关IO */
    ESP_LOGI(TAG, "Install panel IO");
    esp_lcd_panel_io_handle_t io_handle = NULL;
    esp_lcd_panel_io_spi_config_t io_config = {
        .dc_gpio_num = LCD_PIN_NUM_LCD_DC,
        .cs_gpio_num = LCD_PIN_NUM_LCD_CS,
        .pclk_hz = LCD_PIXEL_CLOCK_HZ,
        .lcd_cmd_bits = LCD_CMD_BITS,
        .lcd_param_bits = LCD_PARAM_BITS,
        .spi_mode = 0,
        .trans_queue_depth = 10,
        .on_color_trans_done = Notify_lvgl_flush_ready,   // 颜色数据传输完成后调用的回调
        .user_ctx = &disp_drv,   //用户私人数据，直接传递给on_color_trans_done的user_ctx
    };

    /* 创建屏幕IO手柄 */
    ESP_ERROR_CHECK(esp_lcd_new_panel_io_spi((esp_lcd_spi_bus_handle_t)LCD_HOST, &io_config, &io_handle));
    
    /* 创建屏幕句柄，对屏幕进行配置 */
    esp_lcd_panel_handle_t panel_handle = NULL;
    esp_lcd_panel_dev_config_t panel_config = {
        .reset_gpio_num = LCD_PIN_NUM_LCD_RST,    //屏幕复位引脚，没有就填-1
        .rgb_endian = LCD_RGB_ENDIAN_BGR,         //设置 RGB 数据字节序：RGB 或 BGR
        .bits_per_pixel = 16,                     //颜色深度
    };

    /* 根据屏幕参数初始化屏幕的驱动控制芯片 */
    ESP_LOGI(TAG, "Install GC9A01 panel driver");
    ESP_ERROR_CHECK(esp_lcd_new_panel_gc9a01(io_handle, &panel_config, &panel_handle));    //根据参数初始化GC9A01

    ESP_ERROR_CHECK(esp_lcd_panel_reset(panel_handle));    //重置显示器
    ESP_ERROR_CHECK(esp_lcd_panel_init(panel_handle));     //初始化显示器

    ESP_ERROR_CHECK(esp_lcd_panel_invert_color(panel_handle, true));   //设置显示器颜色反转
    ESP_ERROR_CHECK(esp_lcd_panel_mirror(panel_handle, true, false));  //在特定轴上镜像显示器

    /*用户可以在打开屏幕或背光之前将预定义的图案冲洗到屏幕上*/
    ESP_ERROR_CHECK(esp_lcd_panel_disp_on_off(panel_handle, true));    //打开显示器

    /* 打开屏幕背光 */
    ESP_LOGI(TAG, "Turn on LCD backlight");
    gpio_set_level(LCD_PIN_NUM_BK_LIGHT, LCD_BK_LIGHT_ON_LEVEL);       //打开屏幕背光

    /* 初始化LVGL */
    ESP_LOGI(TAG, "Initialize LVGL library");
    lv_init();   //初始化LVGL库

    /* LVGL使用的分配绘制缓冲区 */
    /* LVGL使用的分配绘制缓冲区 建议选择绘制缓冲区的大小至少为屏幕大小的 1/10  */
    lv_color_t *buf1 = heap_caps_malloc(LCD_H_RES * 20 * sizeof(lv_color_t), MALLOC_CAP_DMA);
    assert(buf1);
    lv_color_t *buf2 = heap_caps_malloc(LCD_H_RES * 20 * sizeof(lv_color_t), MALLOC_CAP_DMA);
    assert(buf2);
    // 初始化 LVGL 绘制缓冲区
    lv_disp_draw_buf_init(&disp_buf, buf1, buf2, LCD_H_RES * 20);

    /* 注册显示器驱动到LVGL */
    ESP_LOGI(TAG, "Register display driver to LVGL");
    /* 使用默认值初始化显示驱动程序。 */
    lv_disp_drv_init(&disp_drv);
    disp_drv.hor_res = LCD_H_RES;       //水平分辨率
    disp_drv.ver_res = LCD_V_RES;       //竖直分辨率
    disp_drv.flush_cb = lvgl_flush_cb;  //将内部缓冲区数据写入到显示器，必须是缓冲区数据传输完成后调用
    disp_drv.drv_update_cb = lvgl_drv_update_callback;   // 当屏幕驱动程序参数更新时调用的函数
    disp_drv.draw_buf = &disp_buf;                       // LVGL将使用此缓冲区绘制屏幕内容
    disp_drv.user_data = panel_handle;
    lv_disp_t *disp = lv_disp_drv_register(&disp_drv);   // 将显示驱动程序注册到 LVGL

    /* 初始化LVGL心跳使用的滴答定时器 */
    ESP_LOGI(TAG, "Install LVGL tick timer");
    /* 配置定时器 */
    const esp_timer_create_args_t lvgl_tick_timer_args = {
        .callback = &lvgl_timer_tick,     //定时器回调函数
        .name = "lvgl_tick"
    };
    esp_timer_handle_t lvgl_tick_timer = NULL;
    ESP_ERROR_CHECK(esp_timer_create(&lvgl_tick_timer_args, &lvgl_tick_timer));   //创建定时器
    ESP_ERROR_CHECK(esp_timer_start_periodic(lvgl_tick_timer, LVGL_TICK_PERIOD_MS * 1000));   //定时器定时启动
    

    /* 使用LVGL测试demo进行测试 */
    ESP_LOGI(TAG, "Display LVGL Meter Widget");
    lvgl_test1_demo_ui(disp);

    while (1) {
        vTaskDelay(pdMS_TO_TICKS(10));  // 提高LVGL的任务优先级和/或减少处理程序周期可以提高性能
        lv_timer_handler();             // 运行lv_timer_handler的任务的优先级应低于运行“lv_tick_inc”的任务
    }
}

/* 缓冲区数据传输完成后，准备对屏幕进行刷新 */
static bool Notify_lvgl_flush_ready(esp_lcd_panel_io_handle_t panel_io, esp_lcd_panel_io_event_data_t *edata, void *user_ctx)
{
    lv_disp_drv_t *disp_driver = (lv_disp_drv_t *)user_ctx;
    lv_disp_flush_ready(disp_driver);
    return false;
}

/* 将缓冲区内的数据写入到显示器进行显示 */
static void lvgl_flush_cb(lv_disp_drv_t *drv, const lv_area_t *area, lv_color_t *color_map)
{
    esp_lcd_panel_handle_t panel_handle = (esp_lcd_panel_handle_t) drv->user_data;
    int offsetx1 = area->x1;
    int offsetx2 = area->x2;
    int offsety1 = area->y1;
    int offsety2 = area->y2;
    //将缓冲区的内容复制到显示的特定区域
    esp_lcd_panel_draw_bitmap(panel_handle, offsetx1, offsety1, offsetx2 + 1, offsety2 + 1, color_map);
}

/* 当屏幕驱动程序参数更新时调用的函数 */ 
static void lvgl_drv_update_callback(lv_disp_drv_t *drv)
{
    esp_lcd_panel_handle_t panel_handle = (esp_lcd_panel_handle_t) drv->user_data;

    switch (drv->rotated) {
    case LV_DISP_ROT_NONE:       //不旋转液晶显示屏
        esp_lcd_panel_swap_xy(panel_handle, false);
        esp_lcd_panel_mirror(panel_handle, true, false);
#if CONFIG_EXAMPLE_LCD_TOUCH_ENABLED
        // Rotate LCD touch
        esp_lcd_touch_set_mirror_y(tp, false);
        esp_lcd_touch_set_mirror_x(tp, false);
#endif
        break;
    case LV_DISP_ROT_90:        //旋转90液晶显示屏
        esp_lcd_panel_swap_xy(panel_handle, true);
        esp_lcd_panel_mirror(panel_handle, true, true);
#if CONFIG_EXAMPLE_LCD_TOUCH_ENABLED
        // Rotate LCD touch
        esp_lcd_touch_set_mirror_y(tp, false);
        esp_lcd_touch_set_mirror_x(tp, false);
#endif
        break;
    case LV_DISP_ROT_180:      //旋转180液晶显示屏
        esp_lcd_panel_swap_xy(panel_handle, false);
        esp_lcd_panel_mirror(panel_handle, false, true);
#if CONFIG_EXAMPLE_LCD_TOUCH_ENABLED
        // Rotate LCD touch
        esp_lcd_touch_set_mirror_y(tp, false);
        esp_lcd_touch_set_mirror_x(tp, false);
#endif
        break;
    case LV_DISP_ROT_270:     //旋转270液晶显示屏
        esp_lcd_panel_swap_xy(panel_handle, true);
        esp_lcd_panel_mirror(panel_handle, false, false);
#if CONFIG_EXAMPLE_LCD_TOUCH_ENABLED
        // Rotate LCD touch
        esp_lcd_touch_set_mirror_y(tp, false);
        esp_lcd_touch_set_mirror_x(tp, false);
#endif
        break;
    }
}

/* LVGL使用的滴答定时器回调函数 */
static void lvgl_timer_tick(void *arg)
{
    /* 告诉 LVGL 已经过去了多少毫秒*/
    lv_tick_inc(LVGL_TICK_PERIOD_MS);
}