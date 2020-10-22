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

#define _MNL_COMMON_C_
/*******************************************************************************
* Dependency
*******************************************************************************/
#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <stdlib.h>
#include <sys/time.h>
#include <cutils/properties.h>
#include "mnl_common.h"
#include "mtk_lbs_utility.h"

#ifdef LOGD
#undef LOGD
#endif
#ifdef LOGW
#undef LOGW
#endif
#ifdef LOGE
#undef LOGE
#endif
#if 0
#define LOGD(...) tag_log(1, "[mnl_linux]", __VA_ARGS__);
#define LOGW(...) tag_log(1, "[mnl_linux] WARNING: ", __VA_ARGS__);
#define LOGE(...) tag_log(1, "[mnl_linux] ERR: ", __VA_ARGS__);
#else
#ifdef LOG_TAG
#undef LOG_TAG
#endif
#define LOG_TAG "mnl_common"

#include <cutils/sockets.h>
#include <log/log.h>     /*logging in logcat*/
#define LOGD(fmt, arg ...) ALOGD("%s: " fmt, __FUNCTION__ , ##arg)
#define LOGW(fmt, arg ...) ALOGW("%s: " fmt, __FUNCTION__ , ##arg)
#define LOGE(fmt, arg ...) ALOGE("%s: " fmt, __FUNCTION__ , ##arg)
#ifdef CONFIG_GPS_ENG_LOAD
#define LOGD_ENG(fmt, arg ...) ALOGD("%s: " fmt, __FUNCTION__ , ##arg)
#else
#define LOGD_ENG(fmt, arg ...) NULL
#endif
#endif
#if ANDROID_MNLD_PROP_SUPPORT
#define MNL_CONFIG_STATUS "persist.vendor.radio.mnl.prop"
#endif
/*******************************************************************************
* structure & enumeration
*******************************************************************************/

/******************************************************************************
 * Functions
******************************************************************************/
#if defined(READ_PROPERTY_FROM_FILE)
/******************************************************************************
Sample for mnl.prop: (for emulator)
-------------------------------------------------------------------------------
init.speed=38400
link.speed=38400
dev.dsp=/dev/ttyS3
dev.gps=/dev/gps
bee.path=/bee
pmtk.conn=socket
pmtk.socket.port=7000
#pmtk.conn=serial
#pmtk.serial.dev=/dev/ttygserial
debug.nema=1 (0:none; 1:normal; 2:full)
debug.mnl=1
******************************************************************************/
const char *mnl_prop_path[] = {
    "/data/vendor/gps/mnl.prop",   /*mainly for target*/
    "/sbin/mnl.prop",   /*mainly for emulator*/
};
#define PROPBUF_SIZE 512
static char propbuf[512];
extern int epo_setconfig;
#define IS_SPACE(ch) ((ch == ' ') || (ch == '\t') || (ch == '\n'))
/******************************************************************************
* Read property from file and overwritting the existing property
******************************************************************************/
int get_prop(char *pStr, char** ppKey, char** ppVal) {
    int len = (int)strlen(pStr);
    char *end = pStr + len;
    char *key = NULL, *val = NULL;

    if (!len) {
        return -1;    // no data
    }
    else if (pStr[0] == '#') {   /*ignore comment*/
        *ppKey = *ppVal = NULL;
        return 0;
    } else if (pStr[len-1] != '\n') {
        if (len >= PROPBUF_SIZE-1) {
            LOGE("%s: buffer is not enough!!\n", __FUNCTION__);
            return -1;
        } else {
            pStr[len] = '\n';
        }
    }
    key = pStr;
    while ((*pStr != '=') && (pStr < end)) pStr++;
    if (pStr >= end) {
        LOGE("%s: '=' is not found!!\n", __FUNCTION__);
        return -1;    // format error
    }

    *pStr++ = '\0';
    while (IS_SPACE(*pStr) && (pStr < end)) pStr++;    // skip space chars
    val = pStr;
    while (!IS_SPACE(*pStr) && (pStr < end)) pStr++;
    *pStr = '\0';
    *ppKey = key;
    *ppVal = val;
    return 0;
}
/*****************************************************************************/
int set_prop(MNL_CONFIG_T* prConfig, char* key, char* val) {
    if (!strcmp(key, "init.speed")) {
        prConfig->init_speed = atoi(val);
    } else if (!strcmp(key, "link.speed")) {
        prConfig->link_speed = atoi(val);
    } else if (!strcmp(key, "dev.dsp")) {
    if (strlen(val) < sizeof(prConfig->dev_dsp))
            MNLD_STRNCPY(prConfig->dev_dsp, val, sizeof(prConfig->dev_dsp));
    } else if (!strcmp(key, "dev.dsp2")) {
    if (strlen(val) < sizeof(prConfig->dev_dsp2))
            MNLD_STRNCPY(prConfig->dev_dsp2, val, sizeof(prConfig->dev_dsp2));
    } else if (!strcmp(key, "dev.gps")) {
    if (strlen(val) < sizeof(prConfig->dev_gps))
        MNLD_STRNCPY(prConfig->dev_gps, val,sizeof(prConfig->dev_gps));
    } else if (!strcmp(key, "bee.path")) {
    if (strlen(val) < sizeof(prConfig->bee_path))
            MNLD_STRNCPY(prConfig->bee_path, val, sizeof(prConfig->bee_path));
    } else if (!strcmp(key, "pmtk.serial.dev")) {
    if (strlen(val) < sizeof(prConfig->dev_dbg))
            MNLD_STRNCPY(prConfig->dev_dbg, val,sizeof(prConfig->dev_dbg));
    } else if (!strcmp(key, "pmtk.conn")) {
        if (!strcmp(val, "serial"))
            prConfig->pmtk_conn = PMTK_CONNECTION_SERIAL;
        else if (!strcmp(val, "socket"))
            prConfig->pmtk_conn = PMTK_CONNECTION_SOCKET;
    }
    else if (!strcmp(key, "pmtk.serial.port")) {
        prConfig->socket_port = atoi(val);
    }
    else if (!strcmp(key, "debug.debug_nmea")) {
        /* it will be set to enable_dbg_log */
        prConfig->debug_nmea = (atoi(val) > 0) ? (1) : (0);
    } else if (!strcmp(key, "debug.mnl")) {
        prConfig->debug_mnl  = strtol(val, NULL, 16);
    } else if (!strcmp(key, "debug.dbg2file")) {
        prConfig->dbg2file  = atoi(val);
    } else if (!strcmp(key, "timeout.monitor")) {
        prConfig->timeout_monitor = atoi(val);
    } else if (!strcmp(key, "timeout.init")) {
        prConfig->timeout_init = atoi(val);
    } else if (!strcmp(key, "timeout.sleep")) {
        prConfig->timeout_sleep = atoi(val);
    } else if (!strcmp(key, "timeout.pwroff")) {
        prConfig->timeout_pwroff = atoi(val);
    } else if (!strcmp(key, "timeout.wakeup")) {
        prConfig->timeout_wakeup = atoi(val);
    } else if (!strcmp(key, "timeout.ttff")) {
        prConfig->timeout_ttff = atoi(val);
    } else if (!strcmp(key, "delay.reset_dsp")) {
        prConfig->delay_reset_dsp = atoi(val);
    } else if (!strcmp(key, "EPO_enabled")) {
        prConfig->EPO_enabled = atoi(val);
        epo_setconfig = 1;
    } else if (!strcmp(key, "BEE_enabled")) {
        prConfig->BEE_enabled = atoi(val);
    } else if (!strcmp(key, "SUPL_enabled")) {
        prConfig->SUPL_enabled = atoi(val);
    } else if (!strcmp(key, "SUPLSI_enabled")) {
        prConfig->SUPLSI_enabled = atoi(val);
    } else if (!strcmp(key, "EPO_priority")) {
        prConfig->EPO_priority = atoi(val);
    } else if (!strcmp(key, "BEE_priority")) {
        prConfig->BEE_priority = atoi(val);
    } else if (!strcmp(key, "SUPL_priority")) {
        prConfig->SUPL_priority = atoi(val);
    } else if (!strcmp(key, "AVAILIABLE_AGE")) {
        prConfig->AVAILIABLE_AGE = atoi(val);
    } else if (!strcmp(key, "RTC_DRIFT")) {
        prConfig->RTC_DRIFT = atoi(val);
    } else if (!strcmp(key, "TIME_INTERVAL")) {
        prConfig->TIME_INTERVAL = atoi(val);
    } else if (!strcmp(key, "TEST_MACHINE")) {
        prConfig->u1AgpsMachine = atoi(val);
    } else if (!strcmp(key, "ACC_SNR")) {
        prConfig->ACCURACY_SNR = atoi(val);
    } else if (!strcmp(key, "GNSS_MODE")) {
        prConfig->GNSSOPMode = atoi(val);
    } else if (!strcmp(key, "DBGLOG_FILE_MAX")) {
        prConfig->dbglog_file_max_size = atoi(val);
    } else if (!strcmp(key, "DBGLOG_FOLDER_MAX")) {
        prConfig->dbglog_folder_max_size = atoi(val);
    } else if ((!strcmp(key, "OFFLOAD_enabled"))) {
        prConfig->OFFLOAD_enabled = atoi(val);
    } else if ((!strcmp(key, "OFFLOAD_testMode"))) {
        prConfig->OFFLOAD_testMode = atoi(val);
    } else if ((!strcmp(key, "OFFLOAD_switchMode"))) {
        prConfig->OFFLOAD_switchMode = atoi(val);
    } else if ((!strcmp(key, "debug.log_hide"))) {
        prConfig->log_hide = atoi(val);
    } else if ((!strcmp(key, "ADC_CAPTURE_enabled"))) {
        prConfig->adc_capture_enabled = atoi(val);
    } else if ((!strcmp(key, "FAST_HTTFF_enabled"))) {
        prConfig->fast_HTTFF = atoi(val);
    #if defined(GPS_SUSPEND_SUPPORT)
    } else if ((!strcmp(key, "SUSPEND_enabled"))) {
        prConfig->SUSPEND_enabled = atoi(val);
    } else if ((!strcmp(key, "SUSPEND_timeout"))) {
        prConfig->SUSPEND_timeout = atoi(val);
    #endif
    } else if ((!strcmp(key, "NFW_CTRL"))) {
        prConfig->bitmap_nfw_ctrl = atoi(val);
    }

    return 0;
}
/*****************************************************************************/
int read_prop(MNL_CONFIG_T* prConfig, const char* name) {
    FILE *fp = fopen(name, "rb");
    char *key, *val;
    if (!fp) {
        LOGD_ENG("%s: open %s fail!\n", __FUNCTION__, name);
        return -1;
    }
    while (fgets(propbuf, sizeof(propbuf), fp)) {
        if (get_prop(propbuf, &key, &val)) {
            LOGD("%s: Get Property fails!!\n", __FUNCTION__);
            fclose(fp);
            return -1;
        }
        if (!key || !val)
            continue;
        // LOGD("%s: Get Property: '%s' => '%s'\n", __FUNCTION__, key, val);
        if (set_prop(prConfig, key, val)) {
            LOGE("%s: Set Property fails!!\n", __FUNCTION__);
            fclose(fp);
            return -1;
        }
    }
    fclose(fp);
    return 0;
}
/*****************************************************************************/
int mnl_utl_load_property(MNL_CONFIG_T* prConfig) {
    int idx;
    int cnt = sizeof(mnl_prop_path)/sizeof(mnl_prop_path[0]);
    int res = 0;
    epo_setconfig = 0;
    for (idx = 0; idx < cnt; idx++) {
        if (!read_prop(prConfig, mnl_prop_path[idx]))
            break;
    }
#if ANDROID_MNLD_PROP_SUPPORT
    // Add for reading property set by YGPS
    char result[PROPERTY_VALUE_MAX] = {0};
    if (property_get(MNL_CONFIG_STATUS, result, NULL)) {
        prConfig->dbg2file = result[2] - '0';
        LOGD_ENG("dbg2file: %d\n", prConfig->dbg2file);
        prConfig->debug_nmea = result[3] - '0';
        LOGD_ENG("debug_nmea:%d \n", prConfig->debug_nmea);
        prConfig->BEE_enabled = result[4] - '0';
        LOGD_ENG("BEE_enabled: %d", prConfig->BEE_enabled);
        // prConfig->test_mode = result[5] - '0';
        // LOGD("test_mode: %d", prConfig->test_mode);
    } else {
        LOGD_ENG("Config is not set yet, ignore");
    }
#endif
    if (idx < cnt)  /* successfully read property from file */  {
        LOGD_ENG("[setting] reading from %s\n", mnl_prop_path[idx]);
        res = 0;
    } else {
        LOGD_ENG("[setting] load default value\n");
        res = -1;
    }
    LOGD("dev_dsp/dev_dsp2/dev_gps : %s %s %s,init_speed/link_speed: %d %d\n",
        prConfig->dev_dsp, prConfig->dev_dsp2, prConfig->dev_gps,
        prConfig->init_speed, prConfig->link_speed);
    LOGD_ENG("pmtk_conn/socket_port/dev_dbg : %d %d %s\n",
        prConfig->pmtk_conn, prConfig->socket_port, prConfig->dev_dbg);
    LOGD_ENG("debug_nmea/debug_mnl: %d 0x%04X,nmea2file/dbg2file: %d/%d\n",
        prConfig->debug_nmea, prConfig->debug_mnl, prConfig->nmea2file, prConfig->dbg2file);
    LOGD_ENG("time-out: %d %d %d %d %d %d\n", prConfig->timeout_init,
        prConfig->timeout_monitor, prConfig->timeout_wakeup, prConfig->timeout_ttff,
        prConfig->timeout_sleep, prConfig->timeout_pwroff);
    LOGD_ENG("EPO_Enabled: %d,BEE_Enabled: %d,SUPL_Enabled: %d,SUPLSI_Enabled: %d\n",
        prConfig->EPO_enabled, prConfig->BEE_enabled, prConfig->SUPL_enabled, prConfig->SUPLSI_enabled);
    LOGD_ENG("EPO_priority: %d,BEE_priority: %d, SUPL_priority: %d\n",
        prConfig->EPO_priority, prConfig->BEE_priority, prConfig->SUPL_priority);
    LOGD_ENG("AVAILIABLE_AGE: %d,RTC_DRIFT: %d,TIME_INTERVAL: %d\n",
        prConfig->AVAILIABLE_AGE, prConfig->RTC_DRIFT, prConfig->TIME_INTERVAL);
    #if defined(GPS_SUSPEND_SUPPORT)
    //LOGD("SUSPEND_enabled: %d, SUSPEND_timeout:%d\n",
    //    prConfig->SUSPEND_enabled, prConfig->SUSPEND_timeout);
    #endif
    return res;
}
#endif

/*****************************************************************************/
int str2int(const char*  p, const char*  end) {
    int   result = 0;
    int   len    = end - p;
    int   sign = 1;

    if (*p == '-') {
        sign = -1;
        p++;
        len = end - p;
    }

    for (; len > 0; len--, p++) {
        int  c;

        if (p >= end)
            return -1;

        c = *p - '0';
        if ((unsigned)c >= 10)
            return -1;

        result = result*10 + c;
    }
    return  sign*result;
}

