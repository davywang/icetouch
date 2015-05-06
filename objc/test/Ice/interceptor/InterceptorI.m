// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <interceptor/InterceptorI.h>
#import <InterceptorTest.h>
#import <TestCommon.h>

@implementation InterceptorI

-(id) init:(ICEObject*) servant_
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
#if defined(__clang__) && !__has_feature(objc_arc)
    servant = [servant_ retain];
#else
    servant = servant_;
#endif
    return self;
}

#if defined(__clang__) && !__has_feature(objc_arc)
-(void) dealloc
{
    [lastOperation release];
    [servant release];
    [super dealloc];
}
#endif
 
-(BOOL) dispatch:(id<ICERequest>) request
{
    ICECurrent* current = [request getCurrent];
    
#if defined(__clang__) && !__has_feature(objc_arc)
    [lastOperation release];
    lastOperation = [current.operation retain];
#else
    lastOperation = current.operation;
#endif

    if([lastOperation isEqualToString:@"addWithRetry"])
    {
        int i = 0;
        for(i = 0; i < 10; ++i)
        {
            @try
            {
                [servant ice_dispatch:request];
                test(NO);
            }
            @catch(TestInterceptorRetryException*)
            {
                //
                // Expected, retry
                //
            }
        }
        
        [(NSMutableDictionary*)current.ctx setObject:@"no" forKey:@"retry"];

        //
        // A successful dispatch that writes a result we discard
        //
        [servant ice_dispatch:request];
    }
      
    lastStatus = [servant ice_dispatch:request];
    return lastStatus;
}
     
-(BOOL) getLastStatus
{
    return lastStatus;
}

-(NSString*) getLastOperation
{
    return lastOperation;
}
 
-(void) clear
{
    lastStatus = NO;
#if defined(__clang__) && !__has_feature(objc_arc)
    [lastOperation release];
#endif
    lastOperation = nil;
}

@end
