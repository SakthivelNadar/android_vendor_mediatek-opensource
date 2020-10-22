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

LOCAL_STATIC_LIBRARIES += \
    libz \
    libselinux \
    libcutils \
    liblog

LOCAL_SRC_FILES := \
    lib/libcrc32.c \
    mkfs.ubifs/compr.c \
    mkfs.ubifs/crc16.c \
    mkfs.ubifs/devtable.c \
    mkfs.ubifs/hashtable/hashtable.c \
    mkfs.ubifs/hashtable/hashtable_itr.c \
    mkfs.ubifs/lpt.c \
    mkfs.ubifs/mkfs.ubifs.c \
    ubi-utils/libubi.c \
    lz4k_encoder/lz4k_compress.c \
    lz4k_encoder/lz4k_decompress.c \
    lz4k_encoder/lz4k_matcher.c \
    lz4k_encoder/divsufsort.c \
    lz4k_encoder/sssort.c \
    lz4k_encoder/trsort.c \
    ../../../../../external/e2fsprogs/lib/uuid/gen_uuid.c \
    ../../../../../external/e2fsprogs/lib/uuid/pack.c \
    ../../../../../external/e2fsprogs/lib/uuid/unpack.c \
    ../../../../../external/e2fsprogs/lib/uuid/unparse.c \
    ../lzo/src/lzo1x_9x.c \

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/../../../../../external/e2fsprogs/lib \
    $(LOCAL_PATH)/include \
    $(LOCAL_PATH)/ubi-utils/include \
    $(LOCAL_PATH)/../lzo/include

LOCAL_CFLAGS += \
    -O2 \
    -DHAVE_INTTYPES_H \
    -DHAVE_UNISTD_H \
    -DHAVE_ERRNO_H \
    -DHAVE_NETINET_IN_H \
    -DHAVE_SYS_IOCTL_H \
    -DHAVE_SYS_MMAN_H \
    -DHAVE_SYS_MOUNT_H \
    -DHAVE_SYS_PRCTL_H \
    -DHAVE_SYS_RESOURCE_H \
    -DHAVE_SYS_SELECT_H \
    -DHAVE_SYS_STAT_H \
    -DHAVE_SYS_TYPES_H \
    -DHAVE_STDLIB_H \
    -DHAVE_STRDUP \
    -DHAVE_MMAP \
    -DHAVE_UTIME_H \
    -DHAVE_GETPAGESIZE \
    -DHAVE_LSEEK64 \
    -DHAVE_LSEEK64_PROTOTYPE \
    -DHAVE_EXT2_IOCTLS \
    -DHAVE_LINUX_FD_H \
    -DHAVE_TYPE_SSIZE_T \
    -DHAVE_SYS_TIME_H \
    -DHAVE_SYSCONF

ifeq ($(strip $(MTK_NAND_UBIFS_LZ4K_SUPPORT)),yes)
LOCAL_CFLAGS += -D__NAND_UBIFS_LZ4K_SUPPORT
endif

LOCAL_MODULE := mkfs_ubifs
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_HOST_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES += \
    lib/libcrc32.c \
    ubi-utils/dictionary.c \
    ubi-utils/libiniparser.c \
    ubi-utils/libubigen.c \
    ubi-utils/ubinize.c \
    ubi-utils/ubiutils-common.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include \
    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2
ifeq ($(strip $(MTK_SLC_BUFFER_SUPPORT)),yes)
LOCAL_CFLAGS +=	-D__MTK_SLC_BUFFER_SUPPORT
endif

LOCAL_MODULE := ubinize
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_HOST_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES += \
    ftl-utils/mkftl.c \
    ../lzo/src/lzo1x_9x.c \
    lz4k_encoder/lz4k_compress.c \
    lz4k_encoder/lz4k_decompress.c \
    lz4k_encoder/lz4k_matcher.c \
    lz4k_encoder/divsufsort.c \
    lz4k_encoder/sssort.c \
    lz4k_encoder/trsort.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include \
    $(LOCAL_PATH)/ubi-utils/include \
    $(LOCAL_PATH)/../lzo/include

LOCAL_CFLAGS := -O2
ifeq ($(strip $(MTK_NAND_UBIFS_LZ4K_SUPPORT)),yes)
LOCAL_CFLAGS += -D__NAND_UBIFS_LZ4K_SUPPORT
endif

LOCAL_MODULE := mkftl
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_HOST_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES += \
    lib/libmtd.c
    lib/libmtd_legacy.c \
    lib/libcrc32.c \
    lib/libfec.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include \
    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := libmtd
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_STATIC_LIBRARIES := libmtd 

LOCAL_SRC_FILES += \
    nandwrite.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include \
    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := nandwrite
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_STATIC_LIBRARIES := libmtd

LOCAL_SRC_FILES += \
    flash_erase.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := flash_erase
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_STATIC_LIBRARIES := libmtd

LOCAL_SRC_FILES += \
    ubi-utils/ubiformat.c \
    ubi-utils/libubi.c \
    ubi-utils/ubiutils-common.c \
    ubi-utils/libscan.c \
    ubi-utils/libubigen.c

LOCAL_C_INCLUDES += \
    $(MTK_ROOT)/include \
    $(MTK_ROOT)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubiformat
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_STATIC_LIBRARIES += \
    libc \
    libstdc++ \
    libmtd

LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_SRC_FILES += \
    ubi-utils/ubiformat.c \
    ubi-utils/libubi.c \
    ubi-utils/ubiutils-common.c \
    ubi-utils/libscan.c \
    ubi-utils/libubigen.c

LOCAL_C_INCLUDES += \
    $(LOCAL_PATH)/include \
    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubiformat_static
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    ubi-utils/libubi.c \
    ubi-utils/ubiutils-common.c

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubi_ota_update
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libmtd

include $(MTK_STATIC_LIBRARY)


include $(CLEAR_VARS)

LOCAL_SRC_FILES := ubi-utils/ubinfo.c \
		ubi-utils/libubi.c \
		ubi-utils/ubiutils-common.c \

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubinfo
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libmtd

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := ubi-utils/ubiattach.c \
		ubi-utils/libubi.c \
		ubi-utils/ubiutils-common.c \

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubiattach
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libmtd

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := ubi-utils/ubidetach.c \
		ubi-utils/libubi.c \

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubidetach
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libmtd

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := ubi-utils/ubimkvol.c \
		ubi-utils/libubi.c \
		ubi-utils/ubiutils-common.c \

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubimkvol
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libmtd

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := ubi-utils/ubirmvol.c \
		ubi-utils/libubi.c \


LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubirmvol
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libmtd

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := ubi-utils/ubiupdatevol.c \
		ubi-utils/libubi.c \


LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := ubiupdatevol
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libmtd

include $(BUILD_EXECUTABLE)

ifneq ($(strip $(MTK_SLC_BUFFER_SUPPORT)),yes)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := ubi-utils/mtdinfo.c \
		ubi-utils/libubi.c \
		ubi-utils/ubiutils-common.c \
		ubi-utils/libubigen.c \

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/ubi-utils/include

LOCAL_CFLAGS := -O2

LOCAL_MODULE := mtdinfo
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_OWNER := mtk
LOCAL_MODULE_TAGS := optional

LOCAL_STATIC_LIBRARIES := libmtd

include $(BUILD_EXECUTABLE)
endif
