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

ifeq ($(MTK_HWC_SUPPORT), yes)

ifneq ($(findstring 2., $(MTK_HWC_VERSION)),)
LOCAL_SRC_FILES += \
    hwc2_api.cpp
else
LOCAL_SRC_FILES += \
    hwc.cpp
endif

LOCAL_CFLAGS += -DLOG_TAG=\"hwcomposer\"

ifeq ($(MTK_HDMI_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_EXTERNAL_SUPPORT
endif

ifeq ($(MTK_WFD_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_VIRTUAL_SUPPORT
endif

ifneq ($(MTK_PQ_SUPPORT), PQ_OFF)
LOCAL_CFLAGS += -DMTK_PQ_ENHANCE
endif

ifeq ($(MTK_ROTATION_OFFSET_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_ROTATION_OFFSET_SUPPORT
endif

ifeq ($(MTK_GMO_RAM_OPTIMIZE), yes)
LOCAL_CFLAGS += -DMTK_GMO_RAM_OPTIMIZE
endif

ifeq ($(MTK_GLOBAL_PQ_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_GLOBAL_PQ_SUPPORT
endif

ifeq ($(TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS), true)
LOCAL_CFLAGS += -DMTK_FORCE_HWC_COPY_VDS
endif

ifeq ($(TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK), true)
LOCAL_CFLAGS += -DMTK_WITHOUT_PRIMARY_PRESENT_FENCE
endif

ifeq ($(MTK_HDR_VIDEO_SUPPORT), yes)
    LOCAL_CFLAGS += -DMTK_HAS_HDR_DISPLAY
endif

ifeq ($(MTK_VIDEO_TRANSITION), yes)
    LOCAL_CFLAGS += -DMTK_VIDEO_TRANSITION
endif

ifeq ($(MTK_VIDEO_ENHANCEMENT), yes)
    LOCAL_CFLAGS += -DMTK_VIDEO_ENHANCEMENT
endif

ifeq ($(MTK_VIDEO_ENHANCEMENT), yes)
    LOCAL_CFLAGS += -DMTK_VIDEO_ENHANCEMENT
endif

ifeq ($(MTK_GAMEPQ_SUPPORT), yes)
    LOCAL_CFLAGS += -DMTK_GAMEPQ_SUPPORT
endif

ifneq ($(MTK_BASIC_PACKAGE), yes)
ifneq ($(MTK_ADJUST_VSYNC_OFFSET_ACTIVELY), no)
ifneq ($(MTK_MERGE_MDP_DISPLAY), no)
LOCAL_CFLAGS += -DMTK_MERGE_MDP_DISPLAY
endif
endif
endif

ifneq ($(LINUX_KERNEL_VERSION), kernel-3.10)
LOCAL_CFLAGS += -DMTK_CONTROL_POWER_WITH_FRAMEBUFFER_DEVICE
endif

# 0:MHL/HDMI  1:EPAPER  2:LCD
ifneq ($(MTK_DUAL_DISPLAY), )
LOCAL_CFLAGS += -DMTK_DUAL_DISPLAY=$(MTK_DUAL_DISPLAY)
else
LOCAL_CFLAGS += -DMTK_DUAL_DISPLAY=0
endif

ifeq ($(MTK_DUAL_DISPLAY), 1)
ifneq ($(MTK_EPAPER_VENDOR),)
LOCAL_CFLAGS += -DMTK_EPAPER_VENDOR=\"$(MTK_EPAPER_VENDOR)\"
else
LOCAL_CFLAGS += -DMTK_EPAPER_VENDOR=\"dummy\"
endif
else
LOCAL_CFLAGS += -DMTK_EPAPER_VENDOR=NULL
endif

ifeq ($(MTK_AOD_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_AOD_SUPPORT
endif

ifeq ($(MTK_RESOLUTION_SWITCH_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_RESOLUTION_SWITCH_SUPPORT
endif

ifneq ($(MTK_ADJUST_VSYNC_OFFSET_ACTIVELY), no)
ifneq ($(MTK_MERGE_MDP_DISPLAY), no)
ifneq ($(MTK_BASIC_PACKAGE), yes)
LOCAL_CFLAGS += -DMTK_MERGE_MDP_DISPLAY
endif
endif
endif

ifneq ($(findstring 1.2, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_1_2
endif

ifneq ($(findstring 1.3, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_1_3
endif

ifneq ($(findstring 1.4, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_1_4
endif

ifneq ($(findstring 1.5, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_1_5
endif

ifneq ($(findstring 2.0, $(MTK_HWC_VERSION)),)
LOCAL_CFLAGS += -DMTK_HWC_VER_2_0
LOCAL_CFLAGS += -USE_HWC2
endif

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include

LOCAL_STATIC_LIBRARIES += \
    hwcomposer.$(MTK_PLATFORM_DIR).$(MTK_HWC_VERSION)

LOCAL_SHARED_LIBRARIES += \
    libui \
    libutils \
    libcutils \
    liblog \
    libsync \
    libion \
    libion_mtk \
    libdpframework \
    libhardware \
    libgralloc_extra \
    libdl \
    libbinder \
    libpower \
    libhidlbase \
    libhwbinder \
    libhidltransport

ifeq ($(MTK_M4U_SUPPORT), yes)
LOCAL_SHARED_LIBRARIES += libm4u
endif

ifeq ($(MTK_DUAL_DISPLAY), 1)
ifneq ($(MTK_EPAPER_VENDOR),)
LOCAL_SHARED_LIBRARIES += \
    libtcon_$(MTK_EPAPER_VENDOR)
else
LOCAL_SHARED_LIBRARIES += \
    libtcon_dummy
endif
endif

ifeq ($(MTK_SEC_VIDEO_PATH_SUPPORT), yes)
LOCAL_CFLAGS += -DMTK_SVP_SUPPORT
endif

ifneq ($(filter 1.4.0 1.4.0 1.4.0.sp 1.4.1 1.5.0 2.0.0,$(MTK_HWC_VERSION)),)
LOCAL_SHARED_LIBRARIES += libged
endif

ifneq ($(findstring 7.,$(PLATFORM_VERSION)),)
else
ifneq ($(MTK_BASIC_PACKAGE), yes)
LOCAL_SHARED_LIBRARIES += \
    libpq_prot \
    vendor.mediatek.hardware.pq@2.0
endif
LOCAL_CFLAGS += -DBYPASS_WLV1_CHECKING
endif

LOCAL_MODULE := hwcomposer.$(MTK_PLATFORM_DIR)
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := first
include $(BUILS_SHARED_LIBRARY)

endif # MTK_HWC_SUPPORT
