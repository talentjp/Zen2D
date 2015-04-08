//
//  TTGRotate.h
//  Zen2D
//
//  Created by Roger Cheng on 6/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@interface TTGRotate : TTGAnimator

@property (assign) float startRotation;
@property (assign) float totalRotation;

+ (TTGRotate*) rotateBy:(float)degree During:(float)duration;

@end
