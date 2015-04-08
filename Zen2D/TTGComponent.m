//
//  TTGComponent.m
//  Zen2D
//
//  Created by Roger Cheng on 7/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGComponent.h"

@implementation TTGComponent
@synthesize parentNode = _parentNode;
@synthesize isActive = _isActive;

- (id)init
{
    if((self = [super init]))
    {
        _parentNode = nil;
        _isActive = NO;
    }
    return self;
}


- (void)cleanup
{
    //To be overridden
}

- (void)attachedToNode
{
     //To be overridden
}

- (void)activate
{
    self.isActive = YES;
}

- (void)deactivate
{
    self.isActive = NO;
}

- (void)update
{
     //To be overridden
}

- (void)reset
{
    //To be overridden
}

- (id)copyWithZone:(NSZone *)zone
{
    TTGComponent* newComp = [[[self class] allocWithZone:zone] init];
    if(newComp)
    {
        newComp.parentNode = nil;
        newComp.isActive = NO;
    }
    return newComp;
}


@end
