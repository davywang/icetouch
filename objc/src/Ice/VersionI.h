// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Version.h>

#include <IceCpp/Version.h>

@interface ICEProtocolVersion (ICEInternal)
+(void) load;
-(ICEProtocolVersion*)initWithProtocolVersion:(const Ice::ProtocolVersion&)arg;
-(Ice::ProtocolVersion)protocolVersion;
+(ICEProtocolVersion*)protocolVersionWithProtocolVersion:(const Ice::ProtocolVersion&)arg;
@end

@interface ICEEncodingVersion (ICEInternal)
+(void) load;
-(ICEEncodingVersion*)initWithEncodingVersion:(const Ice::EncodingVersion&)arg;
-(Ice::EncodingVersion)encodingVersion;
+(ICEEncodingVersion*)encodingVersionWithEncodingVersion:(const Ice::EncodingVersion&)arg;
@end

