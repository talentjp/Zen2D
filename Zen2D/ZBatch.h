//
//  ZSequencer.h
//  Zen2D
//
//  Created by Roger Cheng on 7/7/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@interface ZBatch : ZAnimator
@property (strong) NSMutableArray* arrayAnimators;

+ (ZBatch*) executeAnimators:(ZAnimator*)firstAnimator, ...;

- (void)removeFinishedAnimators;

@end
