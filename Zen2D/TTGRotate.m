//
//  TTGRotate.m
//  Zen2D
//
//  Created by Roger Cheng on 6/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGRotate.h"
#import "TTGNode.h"

@implementation TTGRotate
@synthesize startRotation = _startRotation;
@synthesize totalRotation = _totalRotation;

+ (TTGRotate*)rotateBy:(float)degree During:(float)duration
{
    TTGRotate* rotateBy = [[TTGRotate alloc] init];
    rotateBy.totalRotation = degree;
    rotateBy.duration = duration;
    return rotateBy;
}

- (void)initializeWithNode:(TTGNode *)node
{
    self.nodeToAnimate = node;
    self.startRotation = node.rotation;
}

- (void)animateOneFrame
{
    self.nodeToAnimate.rotation = _startRotation + _totalRotation * self.timeElapsed / self.duration;
}

- (void)animateEndFrame
{
    self.nodeToAnimate.rotation = _startRotation + _totalRotation;
}

@end
