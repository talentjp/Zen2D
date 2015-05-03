//
//  ZSequencer.h
//  Zen2D
//
//  Created by Roger Cheng on 10/30/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@interface ZSequencer : ZAnimator
{
    float _finishedAnimatorTime;
}
@property (strong) NSMutableArray* arrayAnimators;
+ (ZSequencer*) executeInSequence:(ZAnimator*)firstAnimator, ...;

@end