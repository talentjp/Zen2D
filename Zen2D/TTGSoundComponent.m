//
//  TTGSoundComponent.m
//  Zen2D
//
//  Created by Roger Cheng on 4/29/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGSoundComponent.h"
#import "TTGSoundManager.h"

@implementation TTGSoundComponent

- (id)init
{
    if((self = [super init]))
    {
    }
    return self;
}

- (void)loadFile:(NSString *)filename
{
    _soundFileName = filename;
    [[TTGSoundManager sharedManager] preLoadSoundNamed:_soundFileName];
}

- (void)cleanup
{
    //There is nothing to clean up as sound files will remain loaded in the manager for performance
}

- (void)play
{
    [[TTGSoundManager sharedManager] playSoundNamed:_soundFileName];
}

- (id)copyWithZone:(NSZone *)zone
{
    TTGSoundComponent* newComp = [super copyWithZone:zone];
    if(newComp)
    {
        [newComp loadFile:_soundFileName];
    }
    return newComp;
}

@end
