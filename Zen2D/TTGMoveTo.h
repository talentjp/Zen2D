//
//  TTGMoveTo.h
//  Zen2D
//
//  Created by Roger Cheng on 6/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@class TTGNode;

@interface TTGMoveTo : TTGAnimator

@property (assign) CGPoint startPosition;
@property (assign) CGPoint endPosition;

+ (TTGMoveTo*) moveToX:(float)x Y:(float)y During:(float)duration;

@end
