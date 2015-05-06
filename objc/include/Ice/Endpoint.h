// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Config.h>

typedef enum
{
    ICERandom,
    ICEOrdered
} ICEEndpointSelectionType;

extern const int ICETCPEndpointType;
extern const int ICESSLEndpointType;
extern const int ICEUDPEndpointType;

@class ICEEncodingVersion; // Required by ICEOpaqueEndpointInfo

@protocol ICEEndpointInfo<NSObject>
-(ICEShort) type;
-(BOOL) datagram;
-(BOOL) secure;
@end

@interface ICEEndpointInfo : NSObject<ICEEndpointInfo>
{
@protected
    ICEInt timeout;
    BOOL compress;
    ICEShort type_;
    BOOL datagram_;
    BOOL secure_;
}

@property(nonatomic) ICEInt timeout;
@property(nonatomic) BOOL compress;

-(id) init;
@end

@interface ICEIPEndpointInfo : ICEEndpointInfo
{
@private
    NSString* host;
    ICEInt port;
}

@property(nonatomic, retain) NSString* host;
@property(nonatomic) ICEInt port;
@end


@interface ICETCPEndpointInfo : ICEIPEndpointInfo
@end

@interface ICEUDPEndpointInfo : ICEIPEndpointInfo
{
@private
    NSString* mcastInterface;
    ICEInt mcastTtl;
}
@property(nonatomic, retain) NSString* mcastInterface;
@property(nonatomic) ICEInt mcastTtl;
@end

@interface ICEOpaqueEndpointInfo : ICEEndpointInfo
{
@private
    ICEEncodingVersion* rawEncoding;
    NSData* rawBytes;
}
@property(nonatomic, retain) ICEEncodingVersion* rawEncoding;
@property(nonatomic, retain) NSData* rawBytes;
@end

@interface ICESSLEndpointInfo : ICEIPEndpointInfo
@end

@protocol ICEEndpoint <NSObject>
-(ICEEndpointInfo*) getInfo;
-(NSString*) toString;
@end

typedef NSArray ICEEndpointSeq;
typedef NSMutableArray ICEMutableEndpointSeq;
