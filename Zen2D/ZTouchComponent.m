//
//  ZTouchComponent.m
//  Zen2D
//
//  Created by Roger Cheng on 4/28/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZTouchComponent.h"
#import "ZSprite.h"

@implementation ZTouchComponent
@synthesize parentNode = _parentNode;
@synthesize isAbsorbTouch = _isAbsorbTouch;

- (id)init
{
    if((self = [super init]))
    {
        _isAbsorbTouch = YES;
        for(int i = 0; i < MAX_SIMULTANEOUS_TOUCHES; i++)
        {
            _bufferedEvent[i] = _latestEvent[i] = TOUCH_EVENT_NONE;
            _bufferedLocation[i] = _latestLocation[i] = CGPointMake(0, 0);
            _activeTouches[i] = nil;
        }
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Find a new slot for the new touch object
    int curIndex = [self findAvailableTouchIndex];
    if(curIndex != -1) //The touch buffer could be full(albeit very unlikely)
    {
        CGPoint touchLocation = [[ZTouchManager sharedManager] getTouchLocation:touch inScene:_parentNode.parentScene];
        BOOL isTouchingSprite = [_parentNode isLocationWithinSprite:touchLocation];
        if(isTouchingSprite || _parentNode.touchMode == TOUCH_MODE_ALL)
        {
            _bufferedLocation[curIndex] = CGPointMake(touchLocation.x, touchLocation.y);
            if(_isAbsorbTouch)
            {
                [self absorbTouch];
            }
            _bufferedEvent[curIndex] = TOUCH_EVENT_DOWN;
            _activeTouches[curIndex] = touch;
        }
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Touch move does not need to cancel a touch
    int curIndex = [self findIndexForTouch:touch];
    if(curIndex != -1)
    {
        CGPoint touchLocation = [[ZTouchManager sharedManager] getTouchLocation:touch inScene:_parentNode.parentScene];
        _bufferedLocation[curIndex] = CGPointMake(touchLocation.x, touchLocation.y);
        if(_bufferedEvent[curIndex] != TOUCH_EVENT_DOWN) //DOWN event has to be confirmed by user(high priority) before any MOVE event can occur
        {
            _bufferedEvent[curIndex] = TOUCH_EVENT_MOVE;
        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //Touch end does not need to cancel a touch
    int curIndex = [self findIndexForTouch:touch];
    if(curIndex != -1)
    {
        CGPoint touchLocation = [[ZTouchManager sharedManager] getTouchLocation:touch inScene:_parentNode.parentScene];
        _bufferedLocation[curIndex] = CGPointMake(touchLocation.x, touchLocation.y);
        if(_bufferedEvent[curIndex] == TOUCH_EVENT_DOWN)
        {
            _bufferedEvent[curIndex] = TOUCH_EVENT_DOWN_UP; //A very very quick click, treated differently from down and up
        }
        else
        {
            _bufferedEvent[curIndex] = TOUCH_EVENT_UP;
        }
    }
}

-(CGPoint)getLatestLocationAtIndex:(int)index
{
    return _latestLocation[index];
}

-(TouchEvent)getLatestTouchEventAtIndex:(int)index
{
    return _latestEvent[index];
}

- (int)findIndexForTouch:(UITouch *)touch
{
    for(int i = 0; i < MAX_SIMULTANEOUS_TOUCHES; i++)
    {
        if(_activeTouches[i] == touch)
        {
            return i;
        }
    }
    return -1;
}

- (int)findAvailableTouchIndex
{
    for(int i = 0; i < MAX_SIMULTANEOUS_TOUCHES; i++)
    {
        if(!_activeTouches[i])
        {
            return i;
        }
    }
    return -1;
}

- (float)getParentDepth
{
    if([_parentNode isKindOfClass:[ZSprite class]])
    {
        return ((ZSprite*)_parentNode).spriteDepth;
    }
    return 0;
}

- (void)absorbTouch
{
    [[ZTouchManager sharedManager] cancelTouch];
}

- (void)cleanup
{
    [[ZTouchManager sharedManager] removeComponent:self];
}

- (void)attachedToNode {}

- (void)activate
{
    [super activate];
    [[ZTouchManager sharedManager] addTouchComponent:self];
}

- (void)deactivate
{
    [super deactivate];
    [[ZTouchManager sharedManager] removeComponent:self];
}

- (void)update
{
    for(int i = 0; i < MAX_SIMULTANEOUS_TOUCHES; i++)
    {
        _latestEvent[i] = _bufferedEvent[i];
        _latestLocation[i] = _bufferedLocation[i];
        _bufferedEvent[i] = TOUCH_EVENT_NONE;
        _bufferedLocation[i] = CGPointMake(0, 0);
        if(_latestEvent[i] == TOUCH_EVENT_UP || _latestEvent[i] == TOUCH_EVENT_DOWN_UP)
        {
            _activeTouches[i] = nil; ////UP event has to be confirmed by user before removal
        }
    }
}

@end
