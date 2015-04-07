// **********************************************************************
//
// Copyright (c) 2003-2015 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_LICENSE file included in this distribution.
//
// **********************************************************************

#include <Ice/Initialize.h>
#include <Ice/RegisterPlugins.h>

using namespace std;
using namespace Ice;
using namespace IceInternal;

extern "C"
{

Plugin* createIceUDP(const CommunicatorPtr&, const string&, const StringSeq&);
Plugin* createIceTCP(const CommunicatorPtr&, const string&, const StringSeq&);
Plugin* createIceSSL(const CommunicatorPtr&, const string&, const StringSeq&);
Plugin* createIceDiscovery(const CommunicatorPtr&, const string&, const StringSeq&);
Plugin* createIceLocatorDiscovery(const CommunicatorPtr&, const string&, const StringSeq&);

}

RegisterPluginsInit::RegisterPluginsInit()
{
    Ice::registerPluginFactory("IceUDP", createIceUDP, true);
    Ice::registerPluginFactory("IceTCP", createIceTCP, true);
    Ice::registerPluginFactory("IceSSL", createIceSSL, true);
    Ice::registerPluginFactory("IceDiscovery", createIceDiscovery, false);
    Ice::registerPluginFactory("IceLocatorDiscovery", createIceLocatorDiscovery, false);
}
