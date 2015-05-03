//
//  ZFade.m
//  Zen2D
//
//  Created by Roger Cheng on 7/2/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZFade.h"
#import "ZNode.h"

@implementation ZFade

@synthesize startOpacity = _startOpacity;
@synthesize targetOpacity = _targetOpacity;

+ (ZFade*)fadeOutDuring:(float)duration
{
    ZFade* fadeOut = [[ZFade alloc] init];
    fadeOut.duration = duration;
    fadeOut.targetOpacity = 0;
    return fadeOut;
}

+ (ZFade*)fadeInDuring:(float)duration
{
    ZFade* fadeIn = [[ZFade alloc] init];
    fadeIn.duration = duration;
    fadeIn.targetOpacity = 1.0;
    return fadeIn;
}

- (void)initializeWithNode:(ZNode *)node
{
    self.nodeToAnimate = node;
    self.startOpacity = node.opacity;
}

- (void)animateOneFrame
{
    float deltaOpacity = self.targetOpacity - self.startOpacity;
    self.nodeToAnimate.opacity = self.startOpacity + deltaOpacity * self.timeElapsed / self.duration;
}

-(void)animateEndFrame
{
    self.nodeToAnimate.opacity = self.targetOpacity;
}


@end
