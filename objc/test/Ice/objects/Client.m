// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/Ice.h>
#import <TestCommon.h>
#import <objects/TestI.h>

#if !TARGET_OS_IPHONE
#   import <Foundation/NSGarbageCollector.h>
#endif

@interface ClientMyObjectFactory : NSObject<ICEObjectFactory>
@end

@implementation ClientMyObjectFactory

// Note that the object factory must not autorelease the
// returned objects.
-(ICEObject*) create:(NSString*)type
{
    if([type isEqualToString:@"::Test::B"])
    {
        return  [[TestObjectsBI alloc] init];
    }
    else if([type isEqualToString:@"::Test::C"])
    {
        return [[TestObjectsCI alloc] init];
    }
    else if([type isEqualToString:@"::Test::D"])
    {
        return [[TestObjectsDI alloc] init];
    }
    else if([type isEqualToString:@"::Test::E"])
    {
        return [[TestObjectsEI alloc] init];
    }
    else if([type isEqualToString:@"::Test::F"])
    {
        return [[TestObjectsFI alloc] init];
    }
    else if([type isEqualToString:@"::Test::I"])
    {
        return [[TestObjectsI alloc] init];
    }
    else if([type isEqualToString:@"::Test::J"])
    {
        return [[TestObjectsJI alloc] init];
    }
    else if([type isEqualToString:@"::Test::H"])
    {
        return [[TestObjectsHI alloc] init];
    }
    else
    {
        test(NO);
    }
    return nil;
}

-(void) destroy
{
    // Nothing to do
}
@end

static int
run(id<ICECommunicator> communicator)
{
#if defined(__clang__) && !__has_feature(objc_arc)
    id<ICEObjectFactory> factory = [[[ClientMyObjectFactory alloc] init] autorelease];
#else
    id<ICEObjectFactory> factory = [[ClientMyObjectFactory alloc] init];
#endif

    [communicator addObjectFactory:factory sliceId:@"::Test::B"];
    [communicator addObjectFactory:factory sliceId:@"::Test::C"];
    [communicator addObjectFactory:factory sliceId:@"::Test::D"];
    [communicator addObjectFactory:factory sliceId:@"::Test::E"];
    [communicator addObjectFactory:factory sliceId:@"::Test::F"];
    [communicator addObjectFactory:factory sliceId:@"::Test::I"];
    [communicator addObjectFactory:factory sliceId:@"::Test::J"];
    [communicator addObjectFactory:factory sliceId:@"::Test::H"];

    id<TestObjectsInitialPrx> objectsAllTests(id<ICECommunicator>, bool);
    id<TestObjectsInitialPrx> initial = objectsAllTests(communicator, NO);
    [initial shutdown];
    return EXIT_SUCCESS;
}

#if TARGET_OS_IPHONE
#  define main objectsClient
#endif

int
main(int argc, char* argv[])
{
    int status;
    @autoreleasepool
    {
        id<ICECommunicator> communicator = nil;
        @try
        {
            ICEInitializationData* initData = [ICEInitializationData initializationData];
            initData.properties = defaultClientProperties(&argc, argv);
#if TARGET_OS_IPHONE
            initData.prefixTable__ = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"TestObjects", @"::Test", 
                                      nil];
#endif
            communicator = [ICEUtil createCommunicator:&argc argv:argv initData:initData];
            status = run(communicator);
        }
        @catch(ICEException* ex)
        {
            tprintf("%@\n", ex);
            status = EXIT_FAILURE;
        }
        @catch(TestFailedException* ex)
        {
            status = EXIT_FAILURE;
        }

        if(communicator)
        {
            @try
            {
                [communicator destroy];
            }
            @catch(ICEException* ex)
            {
                tprintf("%@\n", ex);
                status = EXIT_FAILURE;
            }
        }
    }
#ifdef ICE_OBJC_GC
    [[NSGarbageCollector defaultCollector] collectExhaustively];
#endif
    return status;
}
