//
//  ZFade.h
//  Zen2D
//
//  Created by Roger Cheng on 7/2/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@interface ZFade : ZAnimator
@property (assign) float startOpacity;
@property (assign) float targetOpacity;

+ (ZFade*) fadeOutDuring:(float)duration;
+ (ZFade*) fadeInDuring:(float)duration;

@end
