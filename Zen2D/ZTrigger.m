//
//  ZTrigger.m
//  Zen2D
//
//  Created by Roger Cheng on 7/7/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZTrigger.h"
#import "ZNode.h"

@implementation ZTrigger
@synthesize animator = _animator;


+ (ZTrigger *)triggerAnimator:(ZAnimator *)animator After:(float)duration
{
    ZTrigger* trigger = [[ZTrigger alloc] init];
    trigger.duration = duration;
    trigger.animator = animator;
    return trigger;
}

- (void)initializeWithNode:(ZNode *)node
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
