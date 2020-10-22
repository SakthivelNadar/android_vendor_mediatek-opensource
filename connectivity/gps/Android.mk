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

$(warning [gps]BOARD_MEDIATEK_USES_GPS = $(BOARD_MEDIATEK_USES_GPS))
LOCAL_PATH := $(call my-dir)

MNLD_BUILD_MAKEFILE := $(LOCAL_PATH)/mtk_mnld/Android.mk

ALL_MAKEFILES := $(wildcard $(LOCAL_PATH)/*/Android.mk)
MNLD_FOLDERS := $(wildcard $(LOCAL_PATH)/mtk_mnld*/Android.mk)
ALL_EXCLUDE_MNLD_MAKEFILES := $(filter-out $(MNLD_FOLDERS),$(wildcard $(LOCAL_PATH)/*/Android.mk))

$(warning ALL_MAKEFILES=$(ALL_MAKEFILES))
$(warning MNLD_FOLDERS=$(MNLD_FOLDERS))
$(warning ALL_EXCLUDE_MNLD_MAKEFILES=$(ALL_EXCLUDE_MNLD_MAKEFILES))
$(warning MNLD_BUILD_MAKEFILE=$(MNLD_BUILD_MAKEFILE))

include $(ALL_EXCLUDE_MNLD_MAKEFILES)
include $(MNLD_BUILD_MAKEFILE)

LOCAL_INIT_RC := gps.rc
