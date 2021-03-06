// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Test.h>
#include <dlfcn.h>

@implementation Test

@synthesize name;
@synthesize sslSupport;
@synthesize runWithSlicedFormat;
@synthesize runWith10Encoding;

+(id)testWithName:(NSString*)name
           server:(int (*)(int, char**))server
           client:(int (*)(int, char**))client
           sslSupport:(BOOL)sslSupport
  runWithSlicedFormat:(BOOL)runWithSlicedFormat
    runWith10Encoding:(BOOL)runWith10Encoding
{
    Test* t = [[Test alloc] init];
    if(t != nil)
    {
        t->name = name;
        t->server = server;
        t->client = client;
        t->sslSupport = sslSupport;
        t->runWithSlicedFormat = runWithSlicedFormat;
        t->runWith10Encoding = runWith10Encoding;
    }
#if defined(__clang__) && !__has_feature(objc_arc)
    return [t autorelease];
#else
    return t;
#endif
}
-(BOOL) hasServer
{
    return server != 0;
}
-(int)server
{
    NSAssert(server != 0, @"server != 0");
    int argc = 0;
    char** argv = 0;
    return (*server)(argc, argv);
}

-(int)client
{
    int argc = 0;
    char** argv = 0;

    NSAssert(client != 0, @"client != 0");
    return (*client)(argc, argv);
}

#if defined(__clang__) && !__has_feature(objc_arc)
-(void)dealloc
{
    [name release];
    [super dealloc];
}
#endif

@end
