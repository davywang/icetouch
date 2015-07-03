LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := Glacier2

LOCAL_MODULE_FILENAME := libGlacier2


LOCAL_SRC_FILES := Application.cpp\
		  Metrics.cpp \
		  Router.cpp \
		  PermissionsVerifier.cpp \
		  Session.cpp \
		  SSLInfo.cpp
		  
LOCAL_EXPORT_C_INCLUDES := \
	$(LOCAL_PATH)/..  $(LOCAL_PATH)/../../include

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/..  $(LOCAL_PATH)/../../include

LOCAL_WHOLE_STATIC_LIBRARIES := iconv	

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

