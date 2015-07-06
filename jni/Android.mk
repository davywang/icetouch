LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

include $(LOCAL_PATH)/../../bzip2/Android.mk \
	$(LOCAL_PATH)/../cpp/src/IceUtil/Android.mk \
	$(LOCAL_PATH)/../cpp/src/Ice/Android.mk \
	$(LOCAL_PATH)/../cpp/src/Glacier2Lib/Android.mk
