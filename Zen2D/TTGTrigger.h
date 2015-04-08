//
//  TTGTrigger.h
//  Zen2D
//
//  Created by Roger Cheng on 7/7/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@interface TTGTrigger : TTGAnimator
@property (strong) TTGAnimator* animator;

+ (TTGTrigger*) triggerAnimator:(TTGAnimator*)animator After:(float)duration;

@end
