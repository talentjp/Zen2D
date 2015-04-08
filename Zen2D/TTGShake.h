//
//  TTGShake.h
//  Zen2D
//
//  Created by Roger Cheng on 6/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@interface TTGShake : TTGAnimator

@property (assign) CGPoint returnPosition;
@property (assign) float distance;

+ (TTGShake*) shakeWithinDistance:(float)distance During:(float)duration;

@end
