// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in
// the ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Config.h>

#import <Ice/Object.h>

@protocol ICESlicedData<NSObject>
@end

@interface ICEUnknownSlicedObject : ICEObject
{
@private
    NSString* unknownTypeId_;
    id<ICESlicedData> slicedData_;
}
-(NSString*) getUnknownTypeId;
-(id<ICESlicedData>) getSlicedData;
@end
