//
//  ZTrigger.h
//  Zen2D
//
//  Created by Roger Cheng on 7/7/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@interface ZTrigger : ZAnimator
@property (strong) ZAnimator* animator;

+ (ZTrigger*) triggerAnimator:(ZAnimator*)animator After:(float)duration;

@end
