//
//  TTGPlaySound.m
//  Zen2D
//
//  Created by Roger Cheng on 7/29/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "TTGPlaySound.h"
#import "TTGSoundManager.h"

@implementation TTGPlaySound
@synthesize soundFilename = _soundFilename;

+ (TTGPlaySound *)playSoundNamed:(NSString *)soundName
{
    TTGPlaySound* playSound = [[TTGPlaySound alloc] init];
    playSound.soundFilename = soundName;
    return playSound;
}

- (void)initializeWithNode:(TTGNode *)node
{
}

- (void)animateOneFrame
{
}

- (void)animateEndFrame
{
    [[TTGSoundManager sharedManager] playSoundNamed:_soundFilename];
}

@end
