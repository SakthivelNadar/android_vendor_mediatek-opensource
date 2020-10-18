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

ifeq (,$(filter $(strip $(MTK_PQ_SUPPORT)), no PQ_OFF))

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES += \
    main_mtk_pq_hal.cpp

LOCAL_SHARED_LIBRARIES += \
    libhidlbase \
    libhidltransport \
    liblog \
    libutils \
    libhardware \
    vendor.mediatek.hardware.pq@2.3

LOCAL_CPPFLAGS += -fexceptions
LOCAL_MODULE:= vendor.mediatek.hardware.pq@2.2-service
LOCAL_INIT_RC := vendor.mediatek.hardware.pq@2.2-service.rc
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)

endif
