//
//  TTGTrigger.m
//  Zen2D
//
//  Created by Roger Cheng on 7/7/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGTrigger.h"
#import "TTGNode.h"

@implementation TTGTrigger
@synthesize animator = _animator;


+ (TTGTrigger *)triggerAnimator:(TTGAnimator *)animator After:(float)duration
{
    TTGTrigger* trigger = [[TTGTrigger alloc] init];
    trigger.duration = duration;
    trigger.animator = animator;
    return trigger;
}

- (void)initializeWithNode:(TTGNode *)node
{
    self.nodeToAnimate = node;
}

- (void)animateEndFrame
{
    //Simply add the animator to the node when time is up
    [self.nodeToAnimate addAnimator:self.animator];
    self.animator = nil;
}

@end
