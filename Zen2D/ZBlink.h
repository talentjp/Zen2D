//
//  ZBlink.h
//  Zen2D
//
//  Created by Roger Cheng on 7/31/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@interface ZBlink : ZAnimator
{
    BOOL  _isIncreasing;
    BOOL _isRepeating;
}
@property (assign) float startOpacity;
@property (assign) float cycle;
+ (ZBlink*) blinkDuring:(float)duration WithCycle:(float)cycleTime; //duration of 0 is repeat
@end
