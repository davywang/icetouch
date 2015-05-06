// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Config.h>

#import <Ice/Communicator.h>
#import <Ice/Properties.h>
#import <Ice/Stream.h>
#import <Ice/Connection.h>
#import <Ice/Version.h>

//
// Forward declarations.
//
@protocol ICELogger;

@protocol ICEDispatcherCall <NSObject>
-(void) run;
@end

@interface ICEInitializationData : NSObject
{
@private
    id<ICEProperties> properties;
    id<ICELogger> logger;
    void(^dispatcher)(id<ICEDispatcherCall>, id<ICEConnection>);
    NSDictionary* prefixTable__;
}
@property(retain, nonatomic) id<ICEProperties> properties;
@property(retain, nonatomic) id<ICELogger> logger;
@property(copy, nonatomic) void(^dispatcher)(id<ICEDispatcherCall>, id<ICEConnection>);
@property(retain, nonatomic) NSDictionary* prefixTable__;

-(id) init:(id<ICEProperties>)properties logger:(id<ICELogger>)logger 
     dispatcher:(void(^)(id<ICEDispatcherCall>, id<ICEConnection>))d;
+(id) initializationData;
+(id) initializationData:(id<ICEProperties>)properties logger:(id<ICELogger>)logger
     dispatcher:(void(^)(id<ICEDispatcherCall>, id<ICEConnection>))d;
// This class also overrides copyWithZone:, hash, isEqual:, and dealloc.
@end

extern ICEEncodingVersion* ICEEncoding_1_0;
extern ICEEncodingVersion* ICEEncoding_1_1;
extern ICEEncodingVersion* ICECurrentEncoding;

extern ICEProtocolVersion* ICEProtocol_1_0;
extern ICEProtocolVersion* ICECurrentProtocol;
extern ICEEncodingVersion* ICECurrentProtocolEncoding;

@interface ICEUtil : NSObject
+(id<ICEProperties>) createProperties;
+(id<ICEProperties>) createProperties:(int*)argc argv:(char*[])argv;
+(id<ICECommunicator>) createCommunicator;
+(id<ICECommunicator>) createCommunicator:(ICEInitializationData *)initData;
+(id<ICECommunicator>) createCommunicator:(int*)argc argv:(char*[])argv;
+(id<ICECommunicator>) createCommunicator:(int*)argc argv:(char*[])argv initData:(ICEInitializationData *)initData;
+(id<ICEInputStream>) createInputStream:(id<ICECommunicator>)communicator data:(NSData*)data;
+(id<ICEInputStream>) createInputStream:(id<ICECommunicator>)c data:(NSData*)data encoding:(ICEEncodingVersion*)e;
+(id<ICEInputStream>) wrapInputStream:(id<ICECommunicator>)communicator data:(NSData*)data;
+(id<ICEInputStream>) wrapInputStream:(id<ICECommunicator>)c data:(NSData*)data encoding:(ICEEncodingVersion*)e;
+(id<ICEOutputStream>) createOutputStream:(id<ICECommunicator>)communicator;
+(id<ICEOutputStream>) createOutputStream:(id<ICECommunicator>)c encoding:(ICEEncodingVersion*)e;
+(NSString*) generateUUID;
+(NSArray*)argsToStringSeq:(int)argc argv:(char*[])argv;
+(void)stringSeqToArgs:(NSArray*)args argc:(int*)argc argv:(char*[])argv;
@end

@interface ICEEncodingVersion(StringConv)
+(ICEEncodingVersion*) encodingVersionWithString:(NSString*)str;
@end

@interface ICEProtocolVersion(StringConv)
+(ICEProtocolVersion*) protocolVersionWithString:(NSString*)str;
@end
