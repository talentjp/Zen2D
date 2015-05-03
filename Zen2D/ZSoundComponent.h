//
//  ZSoundComponent.h
//  Zen2D
//
//  Created by Roger Cheng on 4/29/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import "ZComponent.h"

@interface ZSoundComponent : ZComponent
{
    NSString* _soundFileName;
}

- (void)loadFile:(NSString*)filename;
- (void)play;

@end
