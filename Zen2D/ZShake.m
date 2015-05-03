//
//  ZShake.m
//  Zen2D
//
//  Created by Roger Cheng on 6/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//
#import "ZShake.h"
#import "ZNode.h"

@implementation ZShake
@synthesize returnPosition = _returnPosition;
@synthesize distance = _distance;

+ (ZShake*)shakeWithinDistance:(float)distance During:(float)duration
{
    ZShake* shake = [[ZShake alloc] init];
    shake.duration = duration;
    shake.distance = distance;
    return shake;
}

- (void)initializeWithNode:(ZNode *)node
{
    self.nodeToAnimate = node;
    self.returnPosition = node.spritePosition;
}

- (void)animateOneFrame
{
    self.nodeToAnimate.spritePosition = CGPointMake(_returnPosition.x  + pow(0.85, self.timeElapsed / self.duration * 8.0)
                                      * _distance * sin(self.timeElapsed / self.duration * M_PI * 8.0), //4 round-trips
                                      _returnPosition.y);
}

- (void)animateEndFrame
{
    self.nodeToAnimate.spritePosition = _returnPosition;
}

@end
