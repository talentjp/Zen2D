//
//  TTGPlaySound.h
//  Zen2D
//
//  Created by Roger Cheng on 7/29/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "TTGAnimator.h"

@interface TTGPlaySound : TTGAnimator

@property (copy) NSString* soundFilename;

+ (TTGPlaySound*) playSoundNamed:(NSString*)soundName;

@end
