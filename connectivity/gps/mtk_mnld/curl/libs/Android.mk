ifneq ($(TRUSTONIC_TEE_SUPPORT),yes)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_OWNER := mtk
endif
