# **********************************************************************
#
# Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
#
# This copy of Ice Touch is licensed to you under the terms described in the
# ICE_TOUCH_LICENSE file included in this distribution.
#
# **********************************************************************

top_srcdir	= ../../..

CLIENT		= client
SERVER		= server

TARGETS		= $(CLIENT) $(SERVER)

COBJS		= Client.o \
		  AllTests.o

SOBJS		= BlobjectI.o \
		  Server.o

OBJS		= InvokeTest.o

SRCS		= $(COBJS:.o=.m) \
		  $(SOBJS:.o=.m) \
		  $(OBJS=.o=.m)

SLICE_SRCS	= InvokeTest.ice

include $(top_srcdir)/config/Make.rules

ifeq ($(COMPILE_WITH_GC),yes)
   CPPFLAGS		:= -DICE_OBJC_GC $(CPPFLAGS)
endif

CPPFLAGS	:= -I. -I.. -I../../include $(CPPFLAGS)

$(CLIENT): $(ICEOBJCLIB) $(COBJS) $(OBJS)
	rm -f $@
	$(CXX) $(LDFLAGS) $(STATICLIBSTDFLAG) -o $@ $(COBJS) $(OBJS) $(TEST_LIBS)

$(SERVER): $(ICEOBJCLIB) $(SOBJS) $(OBJS)
	rm -f $@
	$(CXX) $(LDFLAGS) $(STATICLIBSTDFLAG) -o $@ $(SOBJS) $(OBJS) $(TEST_LIBS)

include .depend
