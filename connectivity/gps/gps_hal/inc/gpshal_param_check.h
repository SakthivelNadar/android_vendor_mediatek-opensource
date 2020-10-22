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

#ifndef __GPS_HAL_PARAM_CHECK_H__
#define __GPS_HAL_PARAM_CHECK_H__

#include <string.h>

#if 0 != PARAM_CHECK  // PARAM_CHECK is enabled
    #define GPS_HW_MODULE_OPEN__CHECK_PARAM \
        do { \
            if (&HAL_MODULE_INFO_SYM != module) { \
                ALOGT("-: Bad module object"); \
                return -1;  /* Fail: any non-zero value */ \
            } else if (NULL == id || strcmp(id, HAL_MODULE_INFO_SYM.id)) { \
                ALOGT("-: Bad id"); \
                return -2; \
            } else if (NULL == device) { \
                ALOGT("-: Bad device"); \
                return -3; \
            } \
        } while (0)
    #define GPS_DEVICE__GET_GPS_INTERFACE__CHECK_PARAM \
        do { \
            if (NULL == device || \
                    &HAL_MODULE_INFO_SYM != device->common.module || \
                gps_device__get_gps_interface != device->get_gps_interface) { \
                ALOGT("-: Bad device object"); \
                return NULL; \
            } \
        } while (0)
#elif !defined(NDEBUG)  // assert() is effective
    #define GPS_HW_MODULE_OPEN__CHECK_PARAM \
        do { \
            assert(&HAL_MODULE_INFO_SYM == module); \
            assert(NULL != id); \
            assert(NULL != device); \
            assert(0 == strcmp(id, HAL_MODULE_INFO_SYM.id)); \
        } while (0)
    #define GPS_DEVICE__GET_GPS_INTERFACE__CHECK_PARAM \
        do { \
            assert(NULL != device); \
            assert(&HAL_MODULE_INFO_SYM == device->common.module); \
            assert(gps_device__get_gps_interface == device->get_gps_interface); \
        } while (0)
#else
    // PARAM_CHECK is disabled
    // And assert() is not effective
    #define GPS_HW_MODULE_OPEN__CHECK_PARAM \
        do { \
            UNUSED(module); \
            UNUSED(id); \
        } while (0)
    #define GPS_DEVICE__GET_GPS_INTERFACE__CHECK_PARAM \
        UNUSED(device)
#endif


#endif  // __GPS_HAL_PARAM_CHECK_H__
