LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := IceSSL

LOCAL_MODULE_FILENAME := libIceSSL


LOCAL_SRC_FILES := AcceptorI.cpp\
		  Certificate.cpp \
		  ConnectorI.cpp \
		  EndpointI.cpp \
		  Instance.cpp \
		  PluginI.cpp \
		  TransceiverI.cpp \
		  RFC2253.cpp \
		  TrustManager.cpp \
		  Util.cpp

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/..  $(LOCAL_PATH)/../../include

LOCAL_WHOLE_STATIC_LIBRARIES := libssl
LOCAL_WHOLE_STATIC_LIBRARIES += libcrypto

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
