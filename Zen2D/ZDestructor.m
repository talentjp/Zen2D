//
//  ZDestructor.m
//  Zen2D
//
//  Created by Roger Cheng on 7/27/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZDestructor.h"
#import "ZNode.h"

@implementation ZDestructor

+ (ZDestructor *)killSelf
{
    ZDestructor* newDestructor = [[ZDestructor alloc] init];
    return newDestructor;
}

- (void)initializeWithNode:(ZNode *)node
{
    self.nodeToAnimate = node;
}

- (void)animateEndFrame
{
    self.nodeToAnimate.delayedKill = YES;
}

@end
