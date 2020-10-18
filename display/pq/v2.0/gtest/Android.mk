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

LOCAL_SRC_FILES += \
    pq_test.cpp

LOCAL_SHARED_LIBRARIES := \
    libutils \
    libcutils \
    liblog \
    libpq_prot \
    libhidlbase \
    vendor.mediatek.hardware.pq@2.0

ifeq ($(strip $(MTK_PQ_COLOR_MODE)),MDP)
    LOCAL_CFLAGS += -DMDP_COLOR_ENABLE
else ifeq ($(strip $(MTK_PQ_COLOR_MODE)),DISP_MDP)
    LOCAL_CFLAGS += -DMDP_COLOR_ENABLE
endif

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/../include \
    $(LOCAL_PATH)/../../../../external/gtest/include \
    $(LOCAL_PATH)/../../../../../../../frameworks/base/include \
    $(LOCAL_PATH)/../../../../../../../system/core/base/include

LOCAL_MODULE := pq_gtest
LOCAL_MODULE_TAGS := tests
LOCAL_VENDOR_MODULE := true
LOCAL_PRELINK_MODULE := false

include $(BUILD_NATIVE_TEST)
