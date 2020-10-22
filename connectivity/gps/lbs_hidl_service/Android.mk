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

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

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
    vendor.mediatek.hardware.lbs@1.0

LOCAL_SRC_FILES += \
    lbs_hidl_service.cpp \
    mtk_socket_utils/src/mtk_socket_data_coder.c \
    mtk_socket_utils/src/mtk_socket_utils.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/mtk_socket_utils/inc

LOCAL_MODULE := lbs_hidl_service-impl
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

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
    vendor.mediatek.hardware.lbs@1.0 \
    lbs_hidl_service-impl

LOCAL_SRC_FILES += \
    service.cpp

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/mtk_socket_utils/inc

LOCAL_MODULE := lbs_hidl_service
LOCAL_INIT_RC := lbs_hidl_service.rc
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)
