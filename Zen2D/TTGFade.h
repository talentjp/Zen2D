//
//  TTGFade.h
//  Zen2D
//
//  Created by Roger Cheng on 7/2/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@interface TTGFade : TTGAnimator
@property (assign) float startOpacity;
@property (assign) float targetOpacity;

+ (TTGFade*) fadeOutDuring:(float)duration;
+ (TTGFade*) fadeInDuring:(float)duration;

@end
