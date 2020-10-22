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

ifdef HIDL_V1_0

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES += \
    liblog \
    libhidlbase \
    libhidltransport \
    libutils \
    android.hardware.gnss@1.0 \
    libhardware

LOCAL_SRC_FILES += \
    ThreadCreationWrapper.cpp \
    AGnss.cpp \
    AGnssRil.cpp \
    Gnss.cpp \
    GnssBatching.cpp \
    GnssDebug.cpp \
    GnssGeofencing.cpp \
    GnssMeasurement.cpp \
    GnssNavigationMessage.cpp \
    GnssNi.cpp \
    GnssXtra.cpp \
    GnssConfiguration.cpp \
    GnssUtils.cpp

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/../../gps_hal/inc

LOCAL_CFLAGS += -Werror

LOCAL_MODULE := android.hardware.gnss@1.0-impl-mediatek
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES += \
    liblog \
    libcutils \
    libdl \
    libbase \
    libutils \
    libhardware \
    libbinder \
    libhidlbase \
    libhidltransport \
    android.hardware.gnss@1.0 \

LOCAL_REQUIRED_MODULES += \
    android.hardware.gnss@1.0-impl-mediatek

LOCAL_SRC_FILES += \
    service.cpp \

LOCAL_MODULE := android.hardware.gnss@1.0-service-mediatek
LOCAL_INIT_RC := android.hardware.gnss@1.0-service-mediatek.rc
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)

endif
