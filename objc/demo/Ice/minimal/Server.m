// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Ice.h>
#import <HelloI.h>

int
main(int argc, char* argv[])
{
    int status = 0;
    @autoreleasepool
    {
        id<ICECommunicator> communicator = nil;
        @try
        {
            communicator = [ICEUtil createCommunicator:&argc argv:argv];
            if(argc > 1)
            {
                NSLog(@"%s: too many arguments", argv[0]);
                return 1;
            }

            id<ICEObjectAdapter> adapter = [communicator createObjectAdapterWithEndpoints:@"Hello"
                                                         endpoints:@"tcp -p 10000"];
            [adapter add:[HelloI helloI] identity:[communicator stringToIdentity:@"hello"]];
            [adapter activate];
            [communicator waitForShutdown];
        }
        @catch(ICELocalException* ex)
        {
            NSLog(@"%@", ex);
            status = 1;
        }

        if(communicator != nil)
        {
            @try
            {
                [communicator destroy];
            }
            @catch(ICELocalException* ex)
            {
                NSLog(@"%@", ex);
                status = 1;
            }
        }
    }
    return status;
}
