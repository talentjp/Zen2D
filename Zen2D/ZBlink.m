//
//  ZBlink.m
//  Zen2D
//
//  Created by Roger Cheng on 7/31/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZBlink.h"
#import "ZNode.h"

@implementation ZBlink

@synthesize startOpacity = _startOpacity;
@synthesize cycle = _cycle;

+ (ZBlink *)blinkDuring:(float)duration WithCycle:(float)cycleTime
{
    ZBlink* blink = [[ZBlink alloc] init];
    blink.duration = duration;
    blink.cycle = cycleTime;
    return blink;
}

- (void)initializeWithNode:(ZNode *)node
{
    self.nodeToAnimate = node;
    self.startOpacity = node.opacity;
    _isIncreasing = YES;
    //Override the duration with cycle time if it repeats
    if(self.duration <= 0)
    {
        self.duration = _cycle;
        _isRepeating = YES;
    }
}

- (void)animateOneFrame
{
    if(_isIncreasing)
    {
        self.nodeToAnimate.opacity += 2.0 / _cycle * self.deltaTime;
    }
    else
    {
        self.nodeToAnimate.opacity -= 2.0 / _cycle * self.deltaTime;
    }
    
    if(self.nodeToAnimate.opacity >= 1.0)
    {
        _isIncreasing = NO;
        self.nodeToAnimate.opacity = 1.0;
    }
    else if(self.nodeToAnimate.opacity <= 0.0)
    {
        _isIncreasing = YES;
        self.nodeToAnimate.opacity = 0.0;
    }
}

-(void)animateEndFrame
{
    if(_isRepeating)
    {
        _isIncreasing = YES;    //Reset the direction
        self.duration = _cycle; //Reset the duration
        self.isFinished = NO;   //Reset the completion flag
        self.timeElapsed = 0;   //Reset the timer
    }
    else
    {
        self.nodeToAnimate.opacity = self.startOpacity;
    }
}

@end
