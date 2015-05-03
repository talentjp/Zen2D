//
//  ZVirtualStick.m
//  Zen2D
//
//  Created by Roger Cheng on 6/1/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZVirtualStick.h"
#import "ZSprite.h"
#import "ZTouchComponent.h"
#import "ZScene.h"

const float VIRTUAL_JS_DEPTH = -2000;

@implementation ZVirtualStick
@synthesize leftAnalogPosition = _leftAnalogPosition;

- (id)init
{
    if((self = [super init]))
    {
        self.identifier = @"VirtualJS";
        _leftAnalogPosition = CGPointMake(0,0);
        _leftAnalogCircle = [[ZSprite alloc] initWithFile:@"LeftAnalog.png"];
        _leftThumbCircle  = [[ZSprite alloc] initWithFile:@"LeftAnalogThumb.png"];
        _rightButtonA     = [[ZSprite alloc] initWithFile:@"ButtonA.png"];
        
        _leftAnalogCircle.spriteDepth = VIRTUAL_JS_DEPTH;
        _leftAnalogCircle.identifier = @"LeftAnalogCircle";
        [self attachNode:_leftAnalogCircle];
        
        _leftThumbCircle.spriteDepth = VIRTUAL_JS_DEPTH - 1;
        _leftThumbCircle.identifier = @"LeftThumbCircle";
        [self attachNode:_leftThumbCircle];
        _leftThumbCircle.hide = YES;
        
        _rightButtonA.spriteDepth = VIRTUAL_JS_DEPTH;
        _rightButtonA.identifier = @"RightButtonA";
        [self attachNode:_rightButtonA];
        
        _currentTouch = nil;
        _touchComp = [[ZTouchComponent alloc] init];
        _touchComp.isAbsorbTouch = NO;
        [self addComponent: _touchComp];
        _leftTouchIndex = -1;
    }
    return self;
}

- (void)setParentScene:(ZScene *)parentScene
{
    [super setParentScene:parentScene];
    _leftAnalogCircle.spritePosition = CGPointMake(70.0, 70.0);
    _rightButtonA.spritePosition = CGPointMake(self.parentScene.screenWidth - 60.0, 35.0);
}

- (void)gameUpdate
{
    for(int i = 0; i < MAX_SIMULTANEOUS_TOUCHES; i++)
    {
        CGPoint touchLocation = [_touchComp getLatestLocationAtIndex:i];
        BOOL isTouchingSprite = [_rightButtonA isLocationWithinSprite:touchLocation];
        if(isTouchingSprite && [_touchComp getLatestTouchEventAtIndex:i] == TOUCH_EVENT_DOWN)
        {
            [self buttonAPressed];
        }
        isTouchingSprite = [_leftAnalogCircle isLocationWithinSprite:touchLocation];
        if(isTouchingSprite)
        {
            if([_touchComp getLatestTouchEventAtIndex:i] == TOUCH_EVENT_DOWN)
            {
                _leftThumbCircle.hide = NO;
                [self processLeftAnalogForLocation:touchLocation];
                [self leftAnalogDown];
                _leftTouchIndex = i;
            }
            else if([_touchComp getLatestTouchEventAtIndex:i] == TOUCH_EVENT_MOVE)
            {
                [self processLeftAnalogForLocation:touchLocation];
                [self leftAnalogMoved];
            }
        }
        if(_leftTouchIndex != -1)
        {
            if([_touchComp getLatestTouchEventAtIndex:_leftTouchIndex] == TOUCH_EVENT_UP)
            {
                //Reset everything
                _leftTouchIndex = -1;
                _leftThumbCircle.hide = YES;
                [self leftAnalogUp];
                _leftAnalogPosition = CGPointMake(0,0);
            }
        }
    }
}

- (void)processLeftAnalogForLocation:(CGPoint)touchLocation
{
    [_leftThumbCircle moveToX:touchLocation.x Y:touchLocation.y];
    _leftAnalogPosition.x = (touchLocation.x - _leftAnalogCircle.spritePosition.x) /
    (_leftAnalogCircle.spriteSize.width / 2.0);
    _leftAnalogPosition.y = (touchLocation.y - _leftAnalogCircle.spritePosition.y) /
    (_leftAnalogCircle.spriteSize.height / 2.0);
}

- (void)buttonAPressed
{
    //This method is meant to be overridden
}

- (void)leftAnalogDown
{
    //This method is meant to be overridden
}

- (void)leftAnalogUp
{
    //This method is meant to be overridden
}

- (void)leftAnalogMoved
{
    //This method is meant to be overridden
}

@end
