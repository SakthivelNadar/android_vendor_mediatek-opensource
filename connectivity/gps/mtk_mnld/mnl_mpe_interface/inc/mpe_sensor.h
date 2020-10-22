/*
 * Copyright (C) 2020 The Evolution X Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef SE_SENSOR_LISTENER_API_H
#define SE_SENSOR_LISTENER_API_H

#include "mpe_Attitude.h"
#include "mpe_DR.h"

#ifdef __cplusplus
  extern "C" {
#endif

typedef struct EVENT_DATA {
    float x;
    float y;
    float z;
    int64_t timestamp;
    uint64_t utc_timestamp;
} EVENT_DATA;

unsigned char mpe_sensor_get_listen_mode(void);
void mpe_sensor_set_listen_mode(unsigned char mode);
void mpe_sensor_get_accuracy(INT8 *accuracy);
unsigned char mpe_sensor_init(SENSOR_USER_ID id);
unsigned char mpe_sensor_deinit(SENSOR_USER_ID id);
unsigned char mpe_sensor_start(SENSOR_USER_ID id, SENSOR_TYPE mpe_type, UINT32 periodInMs);
unsigned char mpe_sensor_stop(SENSOR_USER_ID id, SENSOR_TYPE mpe_type);
void mpe_sensor_detect_changing_freq(int64_t curr_time, int64_t *last_time, int *count);
void mpe_sensor_get_calib_accuracy(INT8 *accuracy);
unsigned char mpe_sensor_get_calib_gyr_data(void);
unsigned char mpe_sensor_check_mnl_response(void);
UINT16 mpe_sensor_check_time();
UINT16 mpe_sensor_acquire_Data (IMU *data, uint64_t *data_utc);
void mpe_sensor_run (void);
void mpe_sensor_update_mnl_sec(UINT32 gps_sec, UINT32 leap_sec);
unsigned char mpe_sensor_sync_kernel_utc_time();
void mpe_publish_to_log_buf_pool(char *);
unsigned char mpe_check_sensor_name();

#ifdef __cplusplus
}
#endif

#endif //#ifndef SE_SENSOR_LISTENER_API_H
