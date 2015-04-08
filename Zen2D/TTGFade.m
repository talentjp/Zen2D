//
//  TTGFade.m
//  Zen2D
//
//  Created by Roger Cheng on 7/2/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGFade.h"
#import "TTGNode.h"

@implementation TTGFade

@synthesize startOpacity = _startOpacity;
@synthesize targetOpacity = _targetOpacity;

+ (TTGFade*)fadeOutDuring:(float)duration
{
    TTGFade* fadeOut = [[TTGFade alloc] init];
    fadeOut.duration = duration;
    fadeOut.targetOpacity = 0;
    return fadeOut;
}

+ (TTGFade*)fadeInDuring:(float)duration
{
    TTGFade* fadeIn = [[TTGFade alloc] init];
    fadeIn.duration = duration;
    fadeIn.targetOpacity = 1.0;
    return fadeIn;
}

- (void)initializeWithNode:(TTGNode *)node
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
