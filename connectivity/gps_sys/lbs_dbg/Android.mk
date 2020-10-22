#
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

$(warning "GPS_DBG included in")
$(warning "GPS_DBG MTK_GPS_SUPPORT=yes")

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

MY_LOCAL_PATH := $(LOCAL_PATH)

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/inc

$(warning GPS_DBG inc=$(LOCAL_C_INCLUDES))

LOCAL_SRC_FILES += \
    src/lbs_dbg.cpp \
    src/mtk_socket_data_coder.c \
    src/mtk_socket_utils.c \
    src/log_handler.c \
    src/LbsLogInterface.c

$(warning GPS_DBG SRC=$(LOCAL_SRC_FILES))

LOCAL_SHARED_LIBRARIES += \
    liblog \
    libcutils \
    libdl \
    libbase \
    libhardware \
    libbinder \
    libhidlbase \
    libhidltransport \
    libutils \
    libc \
    vendor.mediatek.hardware.lbs@1.0


LOCAL_MODULE := lbs_dbg
LOCAL_VENDOR_MODULE := false
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_PATH := $(TARGET_OUT_EXECUTABLES)

$(warning GPS_DBG module_path=$(LOCAL_MODULE_PATH))

include $(BUILD_EXECUTABLE)
