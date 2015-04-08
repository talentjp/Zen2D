//
//  TTGSequencer.h
//  Zen2D
//
//  Created by Roger Cheng on 10/30/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@interface TTGSequencer : TTGAnimator
{
    float _finishedAnimatorTime;
}
@property (strong) NSMutableArray* arrayAnimators;
+ (TTGSequencer*) executeInSequence:(TTGAnimator*)firstAnimator, ...;

@end