//
//  TTGSequencer.m
//  Zen2D
//
//  Created by Roger Cheng on 7/7/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGBatch.h"

@implementation TTGBatch
@synthesize arrayAnimators = _arrayAnimators;

- (id)init
{
    if((self = [super init]))
    {
        _arrayAnimators = [NSMutableArray array];
    }
    return self;
}

+ (TTGBatch *)executeAnimators:(TTGAnimator *)firstAnimator, ...
{
    TTGBatch* batch = [[TTGBatch alloc] init];
    TTGAnimator* eachAnimator;
    va_list argumentList;
    [batch.arrayAnimators addObject:firstAnimator];
    batch.duration = firstAnimator.duration;
    va_start(argumentList, firstAnimator);
    while((eachAnimator = va_arg(argumentList, TTGAnimator*)))
    {
        [batch.arrayAnimators addObject:eachAnimator];
        if(batch.duration < eachAnimator.duration)
        {
            //Assumes the largest duration among all the animators
            batch.duration = eachAnimator.duration;
        }
    }
    va_end(argumentList);
    return batch;
}

- (void)initializeWithNode:(TTGNode *)node
{
    for(TTGAnimator* animator in _arrayAnimators)
    {
        [animator initializeWithNode:node];
    }
}

- (void)animateOneFrame
{
    for(TTGAnimator* animator in _arrayAnimators)
    {
        animator.timeElapsed = self.timeElapsed;
        if(self.timeElapsed < animator.duration)
        {
            [animator animateOneFrame];
        }
        else
        {
            [animator animateEndFrame];
            animator.isFinished = YES;
        }
    }
    //Remove animators that finished earlier than the sequencer
    [self removeFinishedAnimators];
}

- (void)animateEndFrame
{
    for(TTGAnimator* animator in _arrayAnimators)
    {
        animator.timeElapsed = self.timeElapsed;
        [animator animateEndFrame];
        animator.isFinished = YES;
    }
    //Since this is the last frame, sequencer has to remove all animators
    [_arrayAnimators removeAllObjects];
}

- (void)removeFinishedAnimators
{
    NSMutableArray* arrayOfFinished = [NSMutableArray array];
    for(TTGAnimator* animator in _arrayAnimators)
    {
        if(animator.isFinished)
        {
            [arrayOfFinished addObject:animator];
        }
    }
    [_arrayAnimators removeObjectsInArray:arrayOfFinished];
}


@end
