//
//  ZShake.h
//  Zen2D
//
//  Created by Roger Cheng on 6/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@interface ZShake : ZAnimator

@property (assign) CGPoint returnPosition;
@property (assign) float distance;

+ (ZShake*) shakeWithinDistance:(float)distance During:(float)duration;

@end
