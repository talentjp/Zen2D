//
//  TTGScale.h
//  Zen2D
//
//  Created by Roger Cheng on 6/20/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@interface TTGScale : TTGAnimator

@property (assign) CGSize startScale;
@property (assign) CGSize endScale;

+ (TTGScale*) scaleToWidth:(float)width Height:(float)height During:(float)duration;

@end
