//
//  TTGAnimator.m
//  Zen2D
//
//  Created by Roger Cheng on 6/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@implementation TTGAnimator

@synthesize duration = _duration;
@synthesize timeElapsed = _timeElapsed;
@synthesize isFinished = _isFinished;
@synthesize nodeToAnimate = _nodeToAnimate;

- (id)init
{
    if((self = [super init]))
    {
        _duration = _timeElapsed = 0;
        _isFinished = NO;
        _nodeToAnimate = nil;
    }
    return self;
}

- (void)animateForDeltaTime:(float)deltaTime
{
    self.deltaTime = deltaTime;
    if(!self.isFinished)
    {
        self.timeElapsed += deltaTime;
        if(self.timeElapsed < self.duration)
        {
            [self animateOneFrame];
        }
        else
        {
            self.isFinished = YES;
            [self animateEndFrame];
        }
    }
}

- (void)animateOneFrame
{
    //To be ovewritten
}

- (void)animateEndFrame
{
    //To be ovewritten
}

- (void)initializeWithNode:(TTGNode *)node
{
    //To be overwritten
}


@end
