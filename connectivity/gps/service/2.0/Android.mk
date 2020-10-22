LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES += \
    liblog \
    libhidlbase \
    libhidltransport \
    libutils \
    android.hardware.gnss@1.0 \
    android.hardware.gnss@1.1 \
    android.hardware.gnss@2.0 \
    android.hardware.gnss.measurement_corrections@1.0 \
    android.hardware.gnss.visibility_control@1.0 \
    libhardware

LOCAL_SRC_FILES += \
    ThreadCreationWrapper.cpp \
    AGnss.cpp \
    AGnssRil.cpp \
    Gnss.cpp \
    GnssBatching.cpp \
    GnssConfiguration.cpp \
    GnssDebug.cpp \
    GnssGeofencing.cpp \
    GnssMeasurement.cpp \
    GnssMeasurementCorrections.cpp \
    GnssNavigationMessage.cpp \
    GnssNi.cpp \
    GnssUtils.cpp \
    GnssVisibilityControl.cpp \
    GnssXtra.cpp

LOCAL_C_INCLUDES += \
    $(MTK_PATH_SOURCE)/hardware/connectivity/gps/gps_hal/inc

LOCAL_CFLAGS += -Werror

LOCAL_MODULE := android.hardware.gnss@2.0-impl-mediatek
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
    android.hardware.gnss@2.0 \

LOCAL_REQUIRED_MODULES += \
    android.hardware.gnss@2.0-impl-mediatek

LOCAL_SRC_FILES += \
    service.cpp \

LOCAL_MODULE := android.hardware.gnss@2.0-service-mediatek
LOCAL_INIT_RC := android.hardware.gnss@2.0-service-mediatek.rc
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE_OWNER := mtk
LOCAL_VENDOR_MODULE := true

include $(BUILD_EXECUTABLE)
