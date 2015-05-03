//
//  ZPlaySound.h
//  Zen2D
//
//  Created by Roger Cheng on 7/29/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZAnimator.h"

@interface ZPlaySound : ZAnimator

@property (copy) NSString* soundFilename;

+ (ZPlaySound*) playSoundNamed:(NSString*)soundName;

@end
