// **********************************************************************
//
// Copyright (c) 2003-2014 ZeroC, Inc. All rights reserved.
//
// This copy of Ice Touch is licensed to you under the terms described in the
// ICE_TOUCH_LICENSE file included in this distribution.
//
// **********************************************************************

#import <Ice/ObjectI.h>
#import <Ice/StreamI.h>
#import <Ice/CurrentI.h>
#import <Ice/Util.h>
#import <Ice/LocalException.h>
#import <Ice/Request.h>

#include <IceCpp/Object.h>
#include <IceCpp/IncomingAsync.h>
#include <IceCpp/Initialize.h>
#include <IceCpp/ObjectAdapter.h>

#import <Foundation/NSAutoreleasePool.h>

int
ICEInternalLookupString(NSString* const array[], size_t count, NSString* __unsafe_unretained str)
{
    size_t low = 0;
    size_t high = count - 1;
    while(low <= high)
    {
        size_t mid = (low + high) / 2;
        switch([array[mid] compare:str])
        {
        case NSOrderedDescending:
            if(mid == 0)
            {
                return -1;
            }
            high = mid - 1;
            break;
        case NSOrderedAscending:
            low = mid + 1;
            break;
        case NSOrderedSame:
            return mid;
        default:
            return -1; // Can't be reached
        }
    }
    return -1;
}

static NSString*
operationModeToString(ICEOperationMode mode)
{
    switch(mode)
    {
    case ICENormal:
        return @"::Ice::Normal";

    case ICENonmutating:
        return @"::Ice::Nonmutating";

    case ICEIdempotent:
        return @"::Ice::Idempotent";

    default:
        return [NSString stringWithFormat:@"unknown value(%d)", mode];
    }
}

void
ICEInternalCheckModeAndSelector(id target, ICEOperationMode expected, SEL sel, ICECurrent* current)
{
    ICEOperationMode received = current.mode;
    if(expected != received)
    {
        if(expected == ICEIdempotent && received == ICENonmutating)
        {
            // 
            // Fine: typically an old client still using the deprecated nonmutating keyword
            //
            
            //
            // Note that expected == Nonmutating and received == Idempotent is not ok:
            // the server may still use the deprecated nonmutating keyword to detect updates
            // and the client should not break this (deprecated) feature.
            //
        }
        else
        {
            ICEMarshalException* ex = [ICEMarshalException marshalException:__FILE__ line:__LINE__];
            [ex setReason_:[NSString stringWithFormat:@"unexpected operation mode. expected = %@ received=%@", 
                                     operationModeToString(expected), operationModeToString(received)]]; 
            @throw ex;
        }
    }

    if(![target respondsToSelector:sel])
    {
        @throw [ICEOperationNotExistException operationNotExistException:__FILE__ 
                                              line:__LINE__ 
                                              id_:current.id_ 
                                              facet:current.facet
                                              operation:current.operation];
    }
}

namespace IceObjC
{

class ObjectI : public ObjectWrapper, public Ice::BlobjectArrayAsync
{
public:

    ObjectI(id<ICEObject>);

    virtual void ice_invoke_async(const Ice::AMD_Object_ice_invokePtr&, 
                                  const std::pair<const Ice::Byte*, const Ice::Byte*>&,
                                  const Ice::Current&);

    virtual ICEObject* getObject()
    {
        return _object;
    }

    // We must explicitely CFRetain/CFRelease so that the garbage
    // collector does not trash the _object.
    virtual void __incRef()
    {
        CFRetain(_object);
    }

    virtual void __decRef()
    {
        CFRelease(_object);
    }

private:

    ICEObject* _object;
};

class BlobjectI : public ObjectWrapper, public Ice::BlobjectArrayAsync
{
public:

    BlobjectI(ICEBlobject*);
    
    virtual void ice_invoke_async(const Ice::AMD_Object_ice_invokePtr&, 
                                  const std::pair<const Ice::Byte*, const Ice::Byte*>&,
                                  const Ice::Current&);

    virtual ICEObject* getObject()
    {
        return _blobject;
    }

    // We must explicitely CFRetain/CFRelease so that the garbage
    // collector does not trash the _blobject.
    virtual void __incRef()
    {
        CFRetain(_blobject);
    }

    virtual void __decRef()
    {
        CFRelease(_blobject);
    }

private:

    ICEBlobject* _blobject;
    id _target;
};

}

IceObjC::ObjectI::ObjectI(id<ICEObject> object) : _object((ICEObject*)object)
{
}

void
IceObjC::ObjectI::ice_invoke_async(const Ice::AMD_Object_ice_invokePtr& cb, 
                                   const std::pair<const Ice::Byte*, const Ice::Byte*>& inParams,
                                   const Ice::Current& current)
{
    ICEInputStream* is = nil;
    ICEOutputStream* os = nil;
    {
        Ice::InputStreamPtr s = Ice::createInputStream(current.adapter->getCommunicator(), inParams);
        is = [ICEInputStream wrapperWithCxxObjectNoAutoRelease:s.get()];
    }
    {
        Ice::OutputStreamPtr s = Ice::createOutputStream(current.adapter->getCommunicator());
        os = [ICEOutputStream wrapperWithCxxObjectNoAutoRelease:s.get()];
    }
    
    NSException* exception = nil;
    BOOL ok = YES; // Keep the compiler happy
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    ICECurrent* c = [[ICECurrent alloc] initWithCurrent:current];
    @try
    {
        ok = [_object dispatch__:c is:is os:os];
    }
    @catch(id ex)
    {
        exception = [ex retain];
    }
    @finally
    {
        [c release];
        [is release];
        [pool drain];
    }

    if(exception != nil)
    {
        [os release];
        rethrowCxxException(exception, true); // True = release the exception.
    }
    
    std::vector<Ice::Byte> outParams;
    [os os]->finished(outParams);
    [os release];
    
    cb->ice_response(ok, std::make_pair(&outParams[0], &outParams[0] + outParams.size()));
}

IceObjC::BlobjectI::BlobjectI(ICEBlobject* blobject) : _blobject(blobject), _target([blobject target__])
{
}

void
IceObjC::BlobjectI::ice_invoke_async(const Ice::AMD_Object_ice_invokePtr& cb, 
                                     const std::pair<const Ice::Byte*, const Ice::Byte*>& inEncaps,
                                     const Ice::Current& current)
{
    NSException* exception = nil;
    BOOL ok = YES; // Keep the compiler happy.
    NSMutableData* outE = nil;

    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    ICECurrent* c = [[ICECurrent alloc] initWithCurrent:current];
    NSData* inE = [NSData dataWithBytesNoCopy:const_cast<Ice::Byte*>(inEncaps.first) 
                                       length:(inEncaps.second - inEncaps.first) 
                                 freeWhenDone:NO];
    @try
    {
        ok = [_target ice_invoke:inE outEncaps:&outE current:c];
        [outE retain];
    }
    @catch(id ex)
    {
        exception = [ex retain];
    }
    @finally
    {
        [c release];
        [pool drain];
    }

    if(exception != nil)
    {
        rethrowCxxException(exception, true); // True = release the exception.
    }
    
    cb->ice_response(ok, std::make_pair((ICEByte*)[outE bytes], (ICEByte*)[outE bytes] + [outE length]));
    [outE release];
}

@implementation ICEInternalPrefixTable
@end

@implementation ICEObject (ICEInternal)

-(id)init
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    object__ = 0;
    delegate__ = 0;
    return self;
}

-(Ice::Object*) object__
{
    @synchronized([self class])
    {
        if(object__ == 0)
        {
            //
            // NOTE: IceObjC::ObjectI implements it own reference counting and there's no need
            // to call __incRef/__decRef here. The C++ object and Objective-C object are sharing
            // the same reference count (the one of the Objective-C object). This is necessary 
            // to properly release both objects when there's either no more C++ handle/ObjC 
            // reference to the object (without this, servants added to the object adapter 
            // couldn't be retained or released easily).
            //
            object__ = (IceObjC::ObjectWrapper*)new IceObjC::ObjectI(self);
        }
    }
    return (IceObjC::ObjectWrapper*)object__;
}

-(void) dealloc
{
    if(object__)
    {
        delete (IceObjC::ObjectWrapper*)object__;
        object__ = 0;
    }
    [delegate__ release];
    [super dealloc];
}

-(void) finalize
{
    if(object__)
    {
        delete (IceObjC::ObjectWrapper*)object__;
        object__ = 0;
    }
    [super finalize];
}

@end

@implementation ICEObject

static NSString* ICEObject_ids__[1] =
{
    @"::Ice::Object"
};

static NSString* ICEObject_all__[4] =
{
    @"ice_id",
    @"ice_ids",
    @"ice_isA",
    @"ice_ping"
};

-(id)initWithDelegate:(id)delegate
{
    self = [super init];
    if(!self)
    {
        return nil;
    }
    
    object__ = 0;
    delegate__ = [delegate retain];
    return self;
}

+(id)objectWithDelegate:(id)delegate
{
    return [[[ICEObject alloc] initWithDelegate:delegate] autorelease];
}

+(BOOL) ice_isA___:(id)servant current:(ICECurrent*)current is:(id<ICEInputStream>)is os:(id<ICEOutputStream>)os
{
    ICEEncodingVersion* encoding = [is startEncapsulation];
    NSString* id__ = [is readString];
    [is endEncapsulation];
    [os startEncapsulation:encoding format:ICEDefaultFormat];
    BOOL ret__ = [servant ice_isA:id__ current:current];
    [os writeBool:ret__];
    [os endEncapsulation];
    return YES;
}

+(BOOL) ice_ping___:(id)servant current:(ICECurrent*)current is:(id<ICEInputStream>)is os:(id<ICEOutputStream>)os
{
    ICEEncodingVersion* encoding = [is startEncapsulation];
    [is endEncapsulation];
    [os startEncapsulation:encoding format:ICEDefaultFormat];
    [servant ice_ping:current];
    [os endEncapsulation];
    return YES;
}

+(BOOL) ice_id___:(id)servant current:(ICECurrent*)current is:(id<ICEInputStream>)is os:(id<ICEOutputStream>)os
{
    ICEEncodingVersion* encoding = [is startEncapsulation];
    [is endEncapsulation];
    [os startEncapsulation:encoding format:ICEDefaultFormat];
    NSString* ret__ = [servant ice_id:current];
    [os writeString:ret__];
    [os endEncapsulation];
    return YES;
}

+(BOOL) ice_ids___:(id)servant current:(ICECurrent*)current is:(id<ICEInputStream>)is os:(id<ICEOutputStream>)os
{
    ICEEncodingVersion* encoding = [is startEncapsulation];
    [is endEncapsulation];
    [os startEncapsulation:encoding format:ICEDefaultFormat];
    NSArray* ret__ = [servant ice_ids:current];
    [os writeStringSeq:ret__];
    [os endEncapsulation];
    return YES;
}

-(BOOL) ice_isA:(NSString*)typeId
{
    return [self ice_isA:typeId current:nil];
}

-(BOOL) ice_isA:(NSString*)typeId current:(ICECurrent*)current
{
    int count, index;
    NSString*const* staticIds = [[self class] staticIds__:&count idIndex:&index];
    return ICEInternalLookupString(staticIds, count, typeId) >= 0;
}

-(void) ice_ping
{
    [self ice_ping:nil];
}

-(void) ice_ping:(ICECurrent*)current
{
    // Nothing to do.
}

-(NSString*) ice_id
{
    return [self ice_id:nil];
}

-(NSString*) ice_id:(ICECurrent*)current
{
    return [[self class] ice_staticId];
}

-(NSArray*) ice_ids
{
    return [self ice_ids:nil];
}

-(NSArray*) ice_ids:(ICECurrent*)current
{
    int count, index;
    NSString*const* staticIds = [[self class] staticIds__:&count idIndex:&index];
    return [NSArray arrayWithObjects:staticIds count:count];
}

+(NSString*) ice_staticId
{
    int count, index;
    NSString*const* staticIds = [self staticIds__:&count idIndex:&index];
    return staticIds[index];
}

-(void) ice_preMarshal
{
}

-(void) ice_postUnmarshal
{
}

+(NSString*const*) staticIds__:(int*)count idIndex:(int*)idx
{
    *count = sizeof(ICEObject_ids__) / sizeof(NSString*);
    *idx = 0;
    return ICEObject_ids__;
}

-(BOOL) ice_dispatch:(id<ICERequest>)request
{
    @try
    {
        ICERequest* requestI = (ICERequest*)request;
        return [requestI callDispatch:self];
    }
    @catch(ICELocalException*)
    {
        @throw;
    }
    return FALSE;
}

-(BOOL) dispatch__:(ICECurrent*)current is:(id<ICEInputStream>)is os:(id<ICEOutputStream>)os
{
    switch(ICEInternalLookupString(ICEObject_all__, sizeof(ICEObject_all__) / sizeof(NSString*), current.operation))
    {
    case 0:
        return [ICEObject ice_id___:self current:current is:is os:os];
    case 1:
        return [ICEObject ice_ids___:self current:current is:is os:os];
    case 2:
        return [ICEObject ice_isA___:self current:current is:is os:os];
    case 3:
        return [ICEObject ice_ping___:self current:current is:is os:os];
    default:
        @throw [ICEOperationNotExistException requestFailedException:__FILE__ 
                                              line:__LINE__ 
                                              id_:current.id_ 
                                              facet:current.facet
                                              operation:current.operation];
    }
}

-(void) write__:(id<ICEOutputStream>)os
{
    [os startObject:nil];
    [self writeImpl__:os];
    [os endObject];
}

-(void) read__:(id<ICEInputStream>)is
{
    [is startObject];
    [self readImpl__:is];
    [is endObject:NO];
}

-(void) writeImpl__:(id<ICEOutputStream>)os
{
    NSAssert(NO, @"writeImpl__ requires override");
}

-(void) readImpl__:(id<ICEInputStream>)is
{
    NSAssert(NO, @"readImpl__ requires override");
}

-(id) copyWithZone:(NSZone*)zone
{
    return [[[self class] allocWithZone:zone] init];
}

-(id)target__
{
    return (delegate__ == 0) ? self : delegate__;
}
@end

@implementation ICEBlobject
-(Ice::Object*) object__
{
    @synchronized([self class])
    {
        if(object__ == 0)
        {
            //
            // NOTE: IceObjC::ObjectI implements it own reference counting and there's no need
            // to call __incRef/__decRef here. The C++ object and Objective-C object are sharing
            // the same reference count (the one of the Objective-C object). This is necessary 
            // to properly release both objects when there's either no more C++ handle/ObjC 
            // reference to the object (without this, servants added to the object adapter 
            // couldn't be retained or released easily).
            //
            object__ = (IceObjC::ObjectWrapper*)new IceObjC::BlobjectI(self);
        }
    }
    return (IceObjC::ObjectWrapper*)object__;
}
@end
