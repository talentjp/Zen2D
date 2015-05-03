//
//  ZPlaySound.m
//  Zen2D
//
//  Created by Roger Cheng on 7/29/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZPlaySound.h"
#import "ZSoundManager.h"

@implementation ZPlaySound
@synthesize soundFilename = _soundFilename;

+ (ZPlaySound *)playSoundNamed:(NSString *)soundName
{
    ZPlaySound* playSound = [[ZPlaySound alloc] init];
    playSound.soundFilename = soundName;
    return playSound;
}

- (void)initializeWithNode:(ZNode *)node
{
}

- (void)animateOneFrame
{
}

- (void)animateEndFrame
{
    [[ZSoundManager sharedManager] playSoundNamed:_soundFilename];
}

@end
