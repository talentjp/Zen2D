//
//  PhysicsTouchNode.m
//  Zen2D
//
//  Created by Roger Cheng on 10/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "PhysicsTouchNode.h"
#import "ZTouchComponent.h"
#import "ZScene.h"

@implementation PhysicsTouchNode

- (id)init
{
    if((self = [super init]))
    {
        //Component based design
        _touchComp = [[ZTouchComponent alloc] init];
        [self addComponent: _touchComp];
        _touchComp.isAbsorbTouch = NO;
    }
    return self;
}

- (void)gameUpdate
{
    if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_DOWN)
    {
        ZNode* nodeToCopy = [self.parentScene findNodeByIdentifier:@"ROCK"];
        ZNode* newNode = [nodeToCopy copy];
        CGPoint newLocation = [_touchComp getLatestLocationAtIndex:0];
        [newNode moveToX:newLocation.x Y:newLocation.y];
        [newNode resetComponents];
        [self.parentScene attachNode:newNode];
    }
}

@end
