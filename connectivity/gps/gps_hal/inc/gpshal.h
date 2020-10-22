/*
 * Copyright (C) 2020 The Evolution X Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#ifndef __GPS_HAL_H__
#define __GPS_HAL_H__

#include "hardware/gps_mtk.h"
#include <pthread.h>

//=========================================================

#define MAX_EPOLL_EVENT 50
#define GNSS_NAME_LEN (255)

//=========================================================

typedef enum {  // state order is important
    GPSHAL_STATE_UNKNOWN,
    GPSHAL_STATE_RESOURCE,
    GPSHAL_STATE_CLEANUP,
    GPSHAL_STATE_INIT,    // == STOP
    GPSHAL_STATE_STOP,    // == INIT
    GPSHAL_STATE_START
} gpshal_state;

typedef struct {
    int       fd_mnl2hal;
    int       fd_worker_epoll;
    pthread_t thd_worker;

    pthread_mutex_t mutex_gps_state_intent;
    gpshal_state    gps_state_intent;  // what we want
    gpshal_state    gps_state;  // what we are, but we may fail to change it
    int             gps_cap;
    char            gps_name[GNSS_NAME_LEN];
    char            proxy_apps[HAL_NFW_USER_NUM_MAX*HAL_NFW_USER_NAME_LEN];  //NFW user app list

    GpsCallbacks_ext* gps_cbs;
    AGpsCallbacks*    agps_cbs;
    GpsNiCallbacks*   gpsni_cbs;
    AGpsRilCallbacks* agpsril_cbs;
    GpsMeasurementCallbacks_ext*       meas_cbs;
    MeasurementCorrectionCallbacks_ext* meas_correct_cbs;
    GnssVisibilityControlCallback_ext* visibility_control_cbs;
    GpsNavigationMessageCallbacks* navimsg_cbs;
    GpsGeofenceCallbacks* geofence_cbs;
    VzwDebugCallbacks* vzw_debug_cbs;
} gpshal_context_t;

//=========================================================

extern gpshal_context_t g_gpshal_ctx;
extern const AGpsInterface_ext mtk_agps_inf;
extern const GpsNiInterface  mtk_gps_ni_inf;
extern const AGpsRilInterface_ext mtk_agps_ril_inf;
extern const GpsGeofencingInterface mtkGeofence_inf;


//=========================================================

extern const char* gpshal_state_to_string(gpshal_state state);

extern int gpshal_gpscbs_save(GpsCallbacks_ext* src);

extern void gpshal_set_gps_state_intent(gpshal_state newState);

extern void gpshal2mnl_gps_init();
extern void gpshal2mnl_gps_start();
extern void gpshal2mnl_gps_stop();
extern void gpshal2mnl_gps_cleanup();

extern void gpshal_worker_thread(void *arg);

#endif  //  __GPS_HAL_DEBUG_H__
