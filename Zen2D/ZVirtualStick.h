//
//  ZVirtualStick.h
//  Zen2D
//
//  Created by Roger Cheng on 6/1/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZNode.h"

@class ZSprite;
@class ZTouchComponent;

@interface ZVirtualStick : ZNode
{
    ZSprite* _leftAnalogCircle;
    ZSprite* _leftThumbCircle;
    ZSprite* _rightButtonA;
    UITouch* _currentTouch;
    ZTouchComponent* _touchComp;
    int _leftTouchIndex;
}

@property (assign) CGPoint leftAnalogPosition;

- (void) processLeftAnalogForLocation:(CGPoint)touchLocation;
- (void) buttonAPressed;
- (void) leftAnalogDown;
- (void) leftAnalogUp;
- (void) leftAnalogMoved;
@end
