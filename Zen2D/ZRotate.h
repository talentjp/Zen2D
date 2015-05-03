//
//  ZRotate.h
//  Zen2D
//
//  Created by Roger Cheng on 6/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@interface ZRotate : ZAnimator

@property (assign) float startRotation;
@property (assign) float totalRotation;

+ (ZRotate*) rotateBy:(float)degree During:(float)duration;

@end
