//
//  ZRotate.m
//  Zen2D
//
//  Created by Roger Cheng on 6/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZRotate.h"
#import "ZNode.h"

@implementation ZRotate
@synthesize startRotation = _startRotation;
@synthesize totalRotation = _totalRotation;

+ (ZRotate*)rotateBy:(float)degree During:(float)duration
{
    ZRotate* rotateBy = [[ZRotate alloc] init];
    rotateBy.totalRotation = degree;
    rotateBy.duration = duration;
    return rotateBy;
}

- (void)initializeWithNode:(ZNode *)node
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
