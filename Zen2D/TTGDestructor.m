//
//  TTGDestructor.m
//  Zen2D
//
//  Created by Roger Cheng on 7/27/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGDestructor.h"
#import "TTGNode.h"

@implementation TTGDestructor

+ (TTGDestructor *)killSelf
{
    TTGDestructor* newDestructor = [[TTGDestructor alloc] init];
    return newDestructor;
}

- (void)initializeWithNode:(TTGNode *)node
{
    self.nodeToAnimate = node;
}

- (void)animateEndFrame
{
    self.nodeToAnimate.delayedKill = YES;
}

@end
