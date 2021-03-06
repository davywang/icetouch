// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#pragma once

#include <Ice/BuiltinSequences.ice>
#include <Ice/Endpoint.ice>

module Test
{

interface TestIntf
{
    void op();
    void opWithPayload(Ice::ByteSeq seq);
    void shutdown();
};

interface TestIntfController
{
    void holdAdapter();
    void resumeAdapter();
};

};

