//
//  TTGScale.m
//  Zen2D
//
//  Created by Roger Cheng on 6/20/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGScale.h"
#import "TTGNode.h"

@implementation TTGScale

@synthesize startScale = _startScale;
@synthesize endScale = _endScale;

+ (TTGScale*)scaleToWidth:(float)width Height:(float)height During:(float)duration
{
    TTGScale* scaleTo = [[TTGScale alloc] init];
    scaleTo.endScale = CGSizeMake(width, height);
    scaleTo.duration = duration;
    return scaleTo;
}

- (void)initializeWithNode:(TTGNode *)node
{
    self.nodeToAnimate = node;
    self.startScale = node.scale;
}

- (void)animateOneFrame
{
    float newWidth = (_endScale.width - _startScale.width) * self.timeElapsed / self.duration + _startScale.width;
    float newHeight = (_endScale.height - _startScale.height) * self.timeElapsed / self.duration + _startScale.height;
    self.nodeToAnimate.scale = CGSizeMake(newWidth, newHeight);
}

- (void)animateEndFrame
{
    self.nodeToAnimate.scale = self.endScale;
}

@end
