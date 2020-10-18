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
    cust_aal_main.cpp

LOCAL_STATIC_LIBRARIES += \
    libaal_config

LOCAL_SHARED_LIBRARIES += \
    libcutils \
    liblog

LC_MTK_PLATFORM := $(shell echo $(MTK_PLATFORM) | tr A-Z a-z )

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/../../include \
    $(LOCAL_PATH)/../../../../../../../../$(TARGET_KERNEL_SOURCE)/drivers/misc/mediatek/video/$(MTK_PLATFORM_DIR)/dispsys \

ifeq ($(strip $(MTK_ULTRA_DIMMING_SUPPORT)),yes)
LOCAL_CFLAGS += -DMTK_ULTRA_DIMMING_SUPPORT
endif

ifeq ($(strip $(MTK_BACKLIGHT_SMOOTH_SUPPORT)),yes)
LOCAL_CFLAGS += -DSUPPORT_BACKLIGHT_SMOOTH
endif

LOCAL_MODULE:= libaal_cust
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES += \
    AALService.cpp \
    AALLightSensor.cpp

LOCAL_CFLAGS += -DAAL_ANDROID_PLATFORM

ifneq (,$(filter $(strip $(TARGET_BOARD_PLATFORM)), mt6799 mt6779 mt6785))
LOCAL_CFLAGS += -DHAS_DRE30
endif

ifneq (,$(filter $(strip $(TARGET_BOARD_PLATFORM)), mt6779 mt6785))
LOCAL_CFLAGS += -DHAS_YHIST
endif

ifneq (,$(filter $(strip $(TARGET_BOARD_PLATFORM)), mt6570 mt6580 mt6735 mt6735m mt6737m mt6737t mt6753 mt6750 mt6755 mt6757 mt6797 mt6799 mt8163 mt8167 mt8173 mt8168))
LOCAL_CFLAGS += -DSUPPORT_CABC_HW
endif

ifeq ($(strip $(MTK_BACKLIGHT_SMOOTH_SUPPORT)),yes)
LOCAL_CFLAGS += -DSUPPORT_BACKLIGHT_SMOOTH
endif

LOCAL_CFLAGS += -DAAL_SUPPORT_KERNEL_API

LC_MTK_PLATFORM := $(shell echo $(MTK_PLATFORM) | tr A-Z a-z )

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/../../include \
    $(LOCAL_PATH)/../../../../../../../../$(TARGET_KERNEL_SOURCE)/drivers/misc/mediatek/video/$(MTK_PLATFORM_DIR)/dispsys \
    $(LOCAL_PATH)/../../../../../../../../frameworks/hardware/interfaces/sensorservice/libsensorndkbridge \
    $(LOCAL_PATH)/../../../../../../../../hardware/interfaces/sensors/1.0/default/include

LOCAL_SHARED_LIBRARIES += \
    libutils \
    libcutils \
    libdl \
    liblog \
    libaal_mtk \
    libhardware \
    libhidlbase \
    android.frameworks.sensorservice@1.0 \
    android.hardware.sensors@1.0 \
    libsensorndkbridge

LOCAL_MODULE := libaalservice
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)
