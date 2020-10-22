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

LOCAL_PATH:= $(call my-dir)

###############################################################################
# for system image
###############################################################################
include $(CLEAR_VARS)

LOCAL_MODULE := aee_archive
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_OWNER := mtk
LOCAL_SRC_FILES_arm64 := bin/aee_archive64
LOCAL_SRC_FILES_arm := bin/aee_archive
LOCAL_MULTILIB := first
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)

LOCAL_INIT_RC_32 := aee_aed.rc
LOCAL_INIT_RC_64 := aee_aed64.rc

LOCAL_MODULE := aee_aed
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_OWNER := mtk
LOCAL_SRC_FILES_arm := bin/aee_aed
LOCAL_SRC_FILES_arm64 := bin/aee_aed64
LOCAL_MODULE_STEM_32 := aee_aed
LOCAL_MODULE_STEM_64 := aee_aed64
LOCAL_SHARED_LIBRARIES := vendor.mediatek.hardware.log@1.0
LOCAL_MULTILIB := both
include $(BUILD_PREBUILT)

###############################################################################
# for vendor image
###############################################################################
include $(CLEAR_VARS)

LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE := aee_archivev
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES_arm64 := bin/aee_archivev64
LOCAL_SRC_FILES_arm := bin/aee_archivev
LOCAL_MULTILIB := first
include $(BUILD_PREBUILT)


include $(CLEAR_VARS)

LOCAL_INIT_RC_32 := aee_aedv.rc
LOCAL_INIT_RC_64 := aee_aedv64.rc

LOCAL_MODULE := aee_aedv
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_SRC_FILES_arm := bin/aee_aedv
LOCAL_SRC_FILES_arm64 := bin/aee_aedv64
LOCAL_MODULE_STEM_32 := aee_aedv
LOCAL_MODULE_STEM_64 := aee_aedv64
LOCAL_MULTILIB := both
include $(BUILD_PREBUILT)
