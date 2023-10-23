/*
 * SPDX-FileCopyrightText: 2021-2022 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: CC0-1.0
 */

#include <stdio.h>
#include <inttypes.h>
#include "sdkconfig.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"
#include "esp_chip_info.h"
#include "esp_flash.h"

#include "Display_APP.h"


void app_main(void)
{
    xTaskCreatePinnedToCore(Display_APP_Task, "Display_APP_Task", 1024 * 4, NULL, 1, NULL, 0);
}
