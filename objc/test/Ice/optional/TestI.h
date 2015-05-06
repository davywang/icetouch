// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <OptionalTest.h>

@interface InitialI : TestOptionalInitial<TestOptionalInitial>
-(void) shutdown:(ICECurrent *)current;
-(ICEObject*) pingPong:(ICEObject*)obj current:(ICECurrent*)current;
-(BOOL) supportsRequiredParams:(ICECurrent*)current;
-(BOOL) supportsJavaSerializable:(ICECurrent*)current;
-(BOOL) supportsCsharpSerializable:(ICECurrent*)current;
@end
