// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Config.h>

@protocol ICEObjectFactory <NSObject>
-(ICEObject*) create:(NSString*)sliceId NS_RETURNS_RETAINED;
-(void) destroy;
@end

