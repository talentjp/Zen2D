//
//  ZSoundManager.h
//  Zen2D
//
//  Created by Roger Cheng on 4/29/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface ZSoundManager : NSObject
{
    ALCdevice* _openALDevice;
    ALCcontext* _openALContext;
    NSMutableArray* _arraySourceIDs;
    NSMutableDictionary* _tableSoundBuffers;
}

+ (ZSoundManager*) sharedManager;
- (void) initializeSoundDevice;
- (void) releaseAllResources;
- (void) playSoundNamed:(NSString*)filename;
- (void) preLoadSoundNamed:(NSString*)filename;
- (NSNumber*) loadSoundNamed:(NSString*)filename;
- (void) playSoundFromBuffer:(ALuint)bufferID ToSource:(ALuint)sourceID;
- (ALuint) getBestAvailableSource;
@end
