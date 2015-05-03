//
//  ZMoveTo.m
//  Zen2D
//
//  Created by Roger Cheng on 6/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZMoveTo.h"
#import "ZNode.h"

@implementation ZMoveTo

@synthesize startPosition = _startPosition;
@synthesize endPosition = _endPosition;

+ (ZMoveTo*)moveToX:(float)x Y:(float)y During:(float)duration
{
    ZMoveTo* moveTo = [[ZMoveTo alloc] init];
    moveTo.endPosition = CGPointMake(x, y);
    moveTo.duration = duration;
    return moveTo;
}

- (void)initializeWithNode:(ZNode *)node
{
    self.nodeToAnimate = node;
    self.startPosition = node.spritePosition;
}

- (void)animateOneFrame
{
    float newX = (_endPosition.x - _startPosition.x) * self.timeElapsed / self.duration + _startPosition.x;
    float newY = (_endPosition.y - _startPosition.y) * self.timeElapsed / self.duration + _startPosition.y;
    [self.nodeToAnimate moveToX:newX Y:newY];
}

- (void)animateEndFrame
{
    [self.nodeToAnimate moveToX:self.endPosition.x Y:self.endPosition.y];
}

@end
