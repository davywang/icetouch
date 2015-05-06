// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <UIKit/UIKit.h>

#import <Voip.h>

@class ICEInitializationData;
@protocol ICECommunicator;
@protocol GLACIER2RouterPrx;

@interface VoipViewController : UIViewController<UITextFieldDelegate,VoipControl> {
@private
    IBOutlet UITextField* hostnameField;
    IBOutlet UITextField* usernameField;
    IBOutlet UITextField* passwordField;
    IBOutlet UIButton* loginButton;
	IBOutlet UIButton* callButton;
    IBOutlet UISwitch* sslSwitch;
    IBOutlet UISlider* delaySlider;
    IBOutlet UILabel* statusLabel;
    IBOutlet UIActivityIndicatorView* statusActivity;
	
    UITextField* currentField;
    NSString* oldFieldValue;

    // Per session state.
    NSTimer* refreshTimer;
    id<ICECommunicator> communicator;
	id<VoipSessionPrx> session;
	id<GLACIER2RouterPrx> router;
	ICELong sessionTimeout;
}

-(IBAction)login:(id)sender;
-(IBAction)call:(id)sender;
-(IBAction)sslChanged:(id)sender;

@end

