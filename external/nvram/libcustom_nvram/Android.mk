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

ifeq ($(strip $(MTK_HANDSFREE_DMNR_SUPPORT)),yes)
  LOCAL_CFLAGS += -DMTK_HANDSFREE_DMNR_SUPPORT
endif

ifeq ($(MTK_DUAL_MIC_SUPPORT),yes)
LOCAL_CFLAGS += -D__MTK_DUAL_MIC_SUPPORT__
endif

ifeq ($(MTK_VOIP_NORMAL_DMNR),yes)
LOCAL_CFLAGS += -D__MTK_VOIP_NORMAL_DMNR__
endif

ifeq ($(MTK_VOIP_HANDSFREE_DMNR),yes)
LOCAL_CFLAGS += -D__MTK_VOIP_HANDSFREE_DMNR__
endif

ifeq ($(MTK_MERGE_INTERFACE_SUPPORT),yes)
LOCAL_CFLAGS += -D__MTK_MERGE_INTERFACE_SUPPORT__
endif

ifeq ($(MTK_BT_I2S_SUPPORT),yes)
LOCAL_CFLAGS += -D__MTK_BT_I2S_SUPPORT__
endif

ifeq ($(MTK_CONSYS_ADIE), MT6631)
LOCAL_CFLAGS += -DMTK_CONSYS_ADIE_6631
endif

ifeq ($(findstring smartpa, $(MTK_AUDIO_SPEAKER_PATH)), smartpa)
LOCAL_CFLAGS += -D__NXP_SMARTPA_SUPPORT__
endif

ifeq ($(findstring mt6660, $(MTK_AUDIO_SPEAKER_PATH)), mt6660)
LOCAL_CFLAGS += -DMTK_SCP_SMARTPA_SUPPORT
endif

ifeq ($(MTK_ECCCI_C2K),yes)
LOCAL_CFLAGS += -DMTK_ECCCI_C2K
endif

ifeq ($(MTK_ECCCI_C2K),yes)
LOCAL_CFLAGS += -DMTK_ECCCI_C2K
endif

ifeq ($(MTK_FACTORY_GAMMA_SUPPORT),yes)
LOCAL_CFLAGS += -DMTK_FACTORY_GAMMA_SUPPORT
endif

ifeq ($(MTK_EMMC_SUPPORT),yes)
LOCAL_CFLAGS += -DMTK_EMMC_SUPPORT
endif

ifeq ($(MTK_UFS_SUPPORT),yes)
LOCAL_CFLAGS += -DMTK_UFS_SUPPORT
endif

LOCAL_SHARED_LIBRARIES += \
    libc \
    libcutils \
    liblog

LOCAL_SRC_FILES += \
    CFG_file_info.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/../libnvram \
    $(LOCAL_PATH)/../libfile_op \
    $(LOCAL_PATH)/../../audio_utils/common_headers/cgen/cfgfileinc \
    $(LOCAL_PATH)/../../audio_utils/common_headers/cgen

LOCAL_MODULE := libcustom_nvram
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)
