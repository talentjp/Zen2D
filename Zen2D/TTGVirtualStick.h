//
//  TTGVirtualStick.h
//  Zen2D
//
//  Created by Roger Cheng on 6/1/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGNode.h"

@class TTGSprite;
@class TTGTouchComponent;

@interface TTGVirtualStick : TTGNode
{
    TTGSprite* _leftAnalogCircle;
    TTGSprite* _leftThumbCircle;
    TTGSprite* _rightButtonA;
    UITouch* _currentTouch;
    TTGTouchComponent* _touchComp;
    int _leftTouchIndex;
}

@property (assign) CGPoint leftAnalogPosition;

- (void) processLeftAnalogForLocation:(CGPoint)touchLocation;
- (void) buttonAPressed;
- (void) leftAnalogDown;
- (void) leftAnalogUp;
- (void) leftAnalogMoved;
@end
