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

LOCAL_STATIC_LIBRARIES := libmtd_util

LOCAL_SHARED_LIBRARIES += \
    libc \
    liblog \
    libcustom_nvram \
    libnvram

LOCAL_SRC_FILES += \
    libnvram_daemon_callback.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/../libfile_op \
    $(LOCAL_PATH)/../libnvram \
    $(LOCAL_PATH)/../../mtd_util

LOCAL_MODULE := libnvram_daemon_callback
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)
