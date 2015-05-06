// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <UIKit/UIKit.h>

@interface UserController : UITableViewController
{
    IBOutlet UITableView* usersTableView;
    NSMutableArray* users;
}

@property (nonatomic) UITableView* usersTableView;
@property (nonatomic) NSMutableArray* users;

@end
