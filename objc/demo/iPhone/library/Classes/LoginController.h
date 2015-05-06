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

@protocol DemoLibraryPrx;
@class MainController;
@class WaitAlert;
@protocol GLACIER2RouterPrx;

@interface LoginController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
{
@private
    IBOutlet UITextField* hostnameField;
    IBOutlet UITextField* usernameField;
    IBOutlet UITextField* passwordField;
    IBOutlet UIButton* loginButton;
    IBOutlet UISwitch* glacier2Switch;
    IBOutlet UISwitch* sslSwitch;
    IBOutlet UILabel* statusLabel;
    IBOutlet UIActivityIndicatorView* statusActivity;
    UITextField* currentField;
    NSString* oldFieldValue;
    
    MainController *mainController;

    WaitAlert* waitAlert;
    
    id<ICECommunicator> communicator;
    id session;
    id<GLACIER2RouterPrx> router;
    ICELong sessionTimeout;
    id<DemoLibraryPrx> library;
}

-(IBAction)login:(id)sender;
-(void)glacier2Changed:(id)sender;
-(void)sslChanged:(id)sender;

@end
