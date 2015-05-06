// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************


#import <UIKit/UIKit.h>
#import <Ice/Ice.h>

@class RouterI;
@class RootViewController;
@protocol LoggingDelegate;

@interface Logger : NSObject<ICELogger>
{
    NSObject<LoggingDelegate>* delegate;
}

@property NSObject<LoggingDelegate>* delegate;

@end

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
    id<ICECommunicator> communicator;
    RouterI* router;
    Logger* logger;
}

@property (nonatomic) IBOutlet UIWindow *window;
@property (nonatomic) IBOutlet RootViewController *rootViewController;
@property (nonatomic) id<ICECommunicator> communicator;
@property (nonatomic) RouterI* router;
@property (nonatomic) Logger* logger;

-(void)initializeRouter;

@end

