//
//  ZTouchComponent.h
//  Zen2D
//
//  Created by Roger Cheng on 4/28/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZTouchManager.h"
#import "ZComponent.h"

@class ZSprite;

typedef enum{
    TOUCH_EVENT_NONE = 0,
    TOUCH_EVENT_DOWN,
    TOUCH_EVENT_MOVE,
    TOUCH_EVENT_UP,
    TOUCH_EVENT_DOWN_UP
}TouchEvent;

#ifndef _ZTouchComponent_h_
#define _ZTouchComponent_h_
#define MAX_SIMULTANEOUS_TOUCHES 20 //by no means is anyone able to press this fast!
#endif

@interface ZTouchComponent : ZComponent
{
    CGPoint _bufferedLocation[MAX_SIMULTANEOUS_TOUCHES];
    TouchEvent _bufferedEvent[MAX_SIMULTANEOUS_TOUCHES];
    UITouch* _activeTouches[MAX_SIMULTANEOUS_TOUCHES];
    CGPoint _latestLocation[MAX_SIMULTANEOUS_TOUCHES];
    TouchEvent _latestEvent[MAX_SIMULTANEOUS_TOUCHES];
}
@property (weak) ZSprite* parentNode;
@property (assign) bool isAbsorbTouch;

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (CGPoint)getLatestLocationAtIndex:(int)index;
- (TouchEvent)getLatestTouchEventAtIndex:(int)index;
- (float)getParentDepth;
- (void)absorbTouch;
- (int)findIndexForTouch:(UITouch*)touch;
- (int)findAvailableTouchIndex;

@end
