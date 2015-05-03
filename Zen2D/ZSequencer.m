//
//  ZSequencer.m
//  Zen2D
//
//  Created by Roger Cheng on 10/30/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZSequencer.h"

@implementation ZSequencer
@synthesize arrayAnimators = _arrayAnimators;

- (id)init
{
    if((self = [super init]))
    {
        _arrayAnimators = [NSMutableArray array];
        _finishedAnimatorTime = 0;
    }
    return self;
}

- (void)initializeWithNode:(ZNode *)node
{
    for(ZAnimator* animator in _arrayAnimators)
    {
        [animator initializeWithNode:node];
    }
}

- (void)animateOneFrame
{
    if([_arrayAnimators count] > 0)
    {
        ZAnimator* animator = [_arrayAnimators objectAtIndex:0];
        animator.timeElapsed = self.timeElapsed - _finishedAnimatorTime;
        if(self.timeElapsed - _finishedAnimatorTime < animator.duration)
        {
            [animator animateOneFrame];
        }
        else
        {
            [animator animateEndFrame];
            animator.isFinished = YES;
            _finishedAnimatorTime += animator.duration;
            [_arrayAnimators removeObjectAtIndex:0];
        }
    }
}

- (void)animateEndFrame
{
    //First is last (if any)
    if([_arrayAnimators count] > 0)
    {
        ZAnimator* animator = [_arrayAnimators objectAtIndex:0];
        animator.timeElapsed = self.timeElapsed - _finishedAnimatorTime;
        [animator animateEndFrame];
        animator.isFinished = YES;
    }
    //Since this is the last frame, sequencer has to remove all animators
    [_arrayAnimators removeAllObjects];
}

+(ZSequencer *)executeInSequence:(ZAnimator *)firstAnimator, ...
{
    ZSequencer* sequencer = [[ZSequencer alloc] init];
    ZAnimator* eachAnimator;
    va_list argumentList;
    [sequencer.arrayAnimators addObject:firstAnimator];
    sequencer.duration = firstAnimator.duration;
    va_start(argumentList, firstAnimator);
    while((eachAnimator = va_arg(argumentList, ZAnimator*)))
    {
        [sequencer.arrayAnimators addObject:eachAnimator];
        sequencer.duration += eachAnimator.duration;
    }
    va_end(argumentList);
    return sequencer;
}

@end
