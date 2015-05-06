// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <SlicingObjectsTestServer.h>
#import <SlicingObjectsForwardServer.h>

@interface TestSlicingObjectsServerI : TestSlicingObjectsServerTestIntf<TestSlicingObjectsServerTestIntf>
{
@private
    TestSlicingObjectsServerPSUnknownException* ex_;
}
@end
