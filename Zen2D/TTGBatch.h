//
//  TTGSequencer.h
//  Zen2D
//
//  Created by Roger Cheng on 7/7/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@interface TTGBatch : TTGAnimator
@property (strong) NSMutableArray* arrayAnimators;

+ (TTGBatch*) executeAnimators:(TTGAnimator*)firstAnimator, ...;

- (void)removeFinishedAnimators;

@end
