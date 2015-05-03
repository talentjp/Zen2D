//
//  ZMoveTo.h
//  Zen2D
//
//  Created by Roger Cheng on 6/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@class ZNode;

@interface ZMoveTo : ZAnimator

@property (assign) CGPoint startPosition;
@property (assign) CGPoint endPosition;

+ (ZMoveTo*) moveToX:(float)x Y:(float)y During:(float)duration;

@end
