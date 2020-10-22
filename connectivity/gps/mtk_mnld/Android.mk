# Copyright (C) 2020 The Evolution X Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifeq ($(MTK_GPS_SUPPORT), yes)

LOCAL_PATH := $(call my-dir)

MY_MNL_PATH := mnl/MNL

include $(CLEAR_VARS)

LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)/$(MY_MNL_PATH)/inc
LOCAL_MODULE := libmnl_headers

include $(BUILD_HEADER_LIBRARY)

$(warning libmnl_headers:$(LOCAL_EXPORT_C_INCLUDE_DIRS))

include $(CLEAR_VARS)

MY_LOCAL_PATH := $(LOCAL_PATH)
$(warning feature_option=$(MTK_GPS_CHIP))

MY_MNL_PATH := mnl/MNL

LOCAL_CFLAGS += -DGPS_SUSPEND_SUPPORT
LOCAL_CFLAGS += -DMTK_GPS_CO_CLOCK_DATA_IN_MD
ifeq ($(TARGET_BUILD_VARIANT), user)
LOCAL_CFLAGS += -DCONFIG_GPS_USER_LOAD
endif
ifeq ($(TARGET_BUILD_VARIANT), userdebug)
LOCAL_CFLAGS += -DCONFIG_GPS_USER_DBG_LOAD
endif
ifeq ($(TARGET_BUILD_VARIANT), eng)
LOCAL_CFLAGS += -DCONFIG_GPS_ENG_LOAD
endif
ifeq ($(MTK_AGPS_APP), yes)
LOCAL_CFLAGS += -DMTK_AGPS_SUPPORT
endif

LOCAL_STATIC_LIBRARIES += libsupl

LOCAL_SHARED_LIBRARIES += \
    libmnl \
    libgeofence \
    libcurl \
    libcutils \
    libc \
    libm \
    libnvram \
    libcrypto \
    libssl \
    libz \
    liblog \
    libhardware \
    libladder \
    libDR \
    libutils \
    android.frameworks.sensorservice@1.0 \
    android.hardware.sensors@1.0 \
    libhidlbase \
    libhidltransport \
    libsensorndkbridge

LOCAL_HEADER_LIBRARIES += \
    libcutils_headers \
    libmnl_headers

LOCAL_EXPORT_HEADER_LIBRARY_HEADERS += libhardware_headers

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/utility/inc \
    $(LOCAL_PATH)/mnl_agps_interface/inc \
    $(LOCAL_PATH)/mnl_at_cmd_interface/inc \
    $(LOCAL_PATH)/mnl_flp_interface/inc \
    $(LOCAL_PATH)/mnl_nlp_interface/inc \
    $(LOCAL_PATH)/mnl_meta_interface/inc \
    $(LOCAL_PATH)/mnl_debug_interface/inc \
    $(LOCAL_PATH)/mnl_log_interface/inc \
    $(LOCAL_PATH)/mnl_geofence_interface/inc \
    $(LOCAL_PATH)/mnld_entity/inc \
    $(LOCAL_PATH)/curl/inc \
    $(LOCAL_PATH)/../../../external/nvram/libnvram \
    $(LOCAL_PATH)/../../../external/libudf/libladder \
    $(LOCAL_PATH)/../../../../../../external/libxml2/include \
    $(LOCAL_PATH)/../../../../../../system/core/libcutils/include_vndk \
    $(LOCAL_PATH)/../../../../../../frameworks/native/include \
    $(LOCAL_PATH)/../../../../../../frameworks/hardware/interfaces/sensorservice/libsensorndkbridge \
    $(LOCAL_PATH)/../../../../../../hardware/interfaces/sensors/1.0/default/include \
    $(LOCAL_PATH)/mnl_mpe_interface/inc

LOCAL_SRC_FILES += \
    mnld_entity/src/mnl2hal_interface.c \
    utility/src/data_coder.c \
    utility/src/mtk_lbs_utility.c \
    utility/src/mtk_socket_data_coder.c \
    utility/src/mtk_socket_utils.c \
    mnl_agps_interface/src/mnl_agps_interface.c \
    mnl_agps_interface/src/mnl2agps_interface.c \
    mnl_agps_interface/src/agps2mnl_interface.c \
    mnl_flp_interface/src/mtk_flp_controller.c \
    mnl_flp_interface/src/mtk_flp_main.c \
    mnl_flp_interface/src/mtk_flp_mnl_interface.c \
    mnl_flp_interface/src/mtk_flp_screen_monitor.c \
    mnl_flp_interface/src/mnl_flp_test_interface.c \
    mnl_geofence_interface/src/mtk_geofence_controller.c \
    mnl_geofence_interface/src/mtk_geofence_main.c \
    mnl_nlp_interface/src/Mnld2NlpUtilsInterface.c \
    mnl_meta_interface/src/Meta2MnldInterface.c \
    mnl_debug_interface/src/Debug2MnldInterface.c \
    mnl_debug_interface/src/Mnld2DebugInterface.c \
    mnl_log_interface/src/LbsLogInterface.c \
    mnl_at_cmd_interface/src/mnl_at_interface.c \
    mnld_entity/src/mnld.c \
    mnld_entity/src/mnld_uti.c \
    mnld_entity/src/gps_controller.c \
    mnld_entity/src/nmea_parser.c \
    mnld_entity/src/epo.c \
    mnld_entity/src/qepo.c \
    mnld_entity/src/mtknav.c \
    mnld_entity/src/mnl_common.c \
    mnld_entity/src/op01_log.c \
    mnld_entity/src/gps_dbg_log.c \
    mnld_entity/src/mpe.c \
    mnl/src/pseudo_mnl.c \
    utility/src/mtk_mnld_dump.cpp \
    mnl_mpe_interface/src/mpe_main.c \
    mnl_mpe_interface/src/mpe_logger.c \
    mnl_mpe_interface/src/mpe_sensor.cpp

LOCAL_MODULE := mnld
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_EXECUTABLES)
LOCAL_VENDOR_MODULE := true
LOCAL_REQUIRED_MODULES := libmnl.so libgeofence.so
LOCAL_MULTILIB := 32

include $(BUILD_EXECUTABLE)
include $(MY_LOCAL_PATH)/mnl/bin/Android.mk
include $(MY_LOCAL_PATH)/curl/libs/Android.mk
include $(MY_LOCAL_PATH)/$(MY_MNL_PATH)/libs/Android.mk
$(warning $(MY_LOCAL_PATH)/$(MY_MNL_PATH)/libs/Android.mk)
endif
