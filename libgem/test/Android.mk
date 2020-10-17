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
    libutils \
    liblog \
    libui_ext

LOCAL_SRC_FILES += \
    test-wdt.cpp

LOCAL_C_INCLUDES += \
    ../inc


LOCAL_MODULE := wdt-test
LOCAL_MODULE_TAGS := tests
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := false
LOCAL_PRELINK_MODULE := false

include $(BUILD_EXECUTABLE)
