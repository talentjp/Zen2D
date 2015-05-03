//
//  ZSoundManager.m
//  Zen2D
//
//  Created by Roger Cheng on 4/29/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZSoundManager.h"

static ZSoundManager* singleton = nil;
static const int MAX_SIMULTANEOUS_SOUNDS = 32;

@implementation ZSoundManager

+ (ZSoundManager *)sharedManager
{
    @synchronized(singleton)
    {
        if(!singleton)
        {
            singleton = [[ZSoundManager alloc] init];
        }
    }
    return singleton;
}

- (id)init
{
    if((self = [super init]))
    {
        singleton = self;
        _arraySourceIDs = [NSMutableArray array];
        _tableSoundBuffers = [NSMutableDictionary dictionary];
        [self initializeSoundDevice];
    }
    
    return singleton;
}


- (void) initializeSoundDevice
{
    _openALDevice = alcOpenDevice(NULL);
    ALenum error = alGetError();
    if(error != AL_NO_ERROR)
    {
        NSLog(@"Error opening device!!");
    }
    _openALContext = alcCreateContext(_openALDevice, NULL);
    alcMakeContextCurrent(_openALContext);
    //First generate 32(seems to be maximum according to some site) source IDs and store them into the array
    for(int i = 0; i < MAX_SIMULTANEOUS_SOUNDS; i++)
    {
        ALuint tempSourceID;
        alGenSources(1,  &tempSourceID);
        [_arraySourceIDs addObject:[NSNumber numberWithUnsignedInt:tempSourceID]];
    }
}

- (void) releaseAllResources
{
    for(NSNumber* number in _arraySourceIDs)
    {
        ALuint sourceToDelete = [number unsignedIntValue];
        alDeleteSources(1, &sourceToDelete);
    }
    _arraySourceIDs = nil;
    
    for(NSNumber* number in [_tableSoundBuffers allValues])
    {
        ALuint bufferToDelete = [number unsignedIntValue];
        alDeleteBuffers(1, &bufferToDelete);
    }
    
    _tableSoundBuffers = nil;
    
    alcDestroyContext(_openALContext);
    alcCloseDevice(_openALDevice);
}


- (void)playSoundNamed:(NSString *)filename
{
    NSNumber* soundBuffer = nil;
    NSString* cafFilename = [NSString stringWithFormat:@"%@.caf", [filename stringByDeletingPathExtension]];
    if((soundBuffer = [_tableSoundBuffers objectForKey:cafFilename]) == nil)
    {
        soundBuffer = [self loadSoundNamed:cafFilename];
    }
    [self playSoundFromBuffer:[soundBuffer unsignedIntValue] ToSource:[self getBestAvailableSource]];
}

- (void)preLoadSoundNamed:(NSString *)filename
{
    NSString* cafFilename = [NSString stringWithFormat:@"%@.caf", [filename stringByDeletingPathExtension]];
    if(![_tableSoundBuffers objectForKey:cafFilename])
    {
        [self loadSoundNamed:cafFilename];
    }
}

- (NSNumber *)loadSoundNamed:(NSString *)filename
{
    NSURL* audioPath = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    ALuint tempBuffer;
    alGenBuffers(1, &tempBuffer);
    AudioFileID afid;
    OSStatus openResult = AudioFileOpenURL((__bridge CFURLRef)audioPath, kAudioFileReadPermission, 0, &afid);
    if( openResult != 0)
    {
        NSLog(@"Error opening the audio file, %@", audioPath);
    }
    
    //For some reason we can only downcast 64 bits(required getting the property) into 32 bits(required reading the bytes) integer
    UInt64 fileSizeInBytes = 0;
    UInt32 propSize = sizeof(fileSizeInBytes);
    OSStatus getSizeResult = AudioFileGetProperty(afid, kAudioFilePropertyAudioDataByteCount, &propSize, &fileSizeInBytes);
    if(getSizeResult != 0)
    {
        NSLog(@"Error determining size of audio file %@", audioPath);
    }
    
    UInt32 bytesRead = (UInt32)fileSizeInBytes;
    void* audioData = malloc(bytesRead);
    OSStatus readBytesResult = AudioFileReadBytes(afid, false, 0, &bytesRead, audioData);
    if(readBytesResult != 0)
    {
        NSLog(@"Error reading data from audio file %@", audioPath);
    }
    AudioFileClose(afid);
    //TODO : Need to determine sound format automatically
    alBufferData(tempBuffer, AL_FORMAT_MONO16, audioData, bytesRead, 44100);
    if(audioData)
    {
        free(audioData);
        audioData = NULL;
    }
    NSNumber* objectToInsert = [NSNumber numberWithUnsignedInt:tempBuffer];
    [_tableSoundBuffers setValue:objectToInsert forKey:filename];
    return objectToInsert;
}

- (ALuint)getBestAvailableSource
{
    for(NSNumber* sourceObject in _arraySourceIDs)
    {
        ALuint tempSourceID = [sourceObject unsignedIntValue];
        ALint sourceState;
        alGetSourcei(tempSourceID, AL_SOURCE_STATE, &sourceState);
        if(sourceState != AL_PLAYING)
            return tempSourceID;
    }
    
    for(NSNumber* sourceObject in _arraySourceIDs)
    {
        ALuint tempSourceID = [sourceObject unsignedIntValue];
        ALint isLooping;
        alGetSourcei(tempSourceID, AL_LOOPING, &isLooping);
        if(!isLooping)
        {
            alSourceStop(tempSourceID);
            return tempSourceID;
        }
    }
    
    //If can't find any non-playing or non-looping sound source, pick randomly any source to return
    ALuint randomlySelectedSourceID = [[_arraySourceIDs objectAtIndex:arc4random() % MAX_SIMULTANEOUS_SOUNDS] unsignedIntValue];
    alSourceStop(randomlySelectedSourceID);
    return randomlySelectedSourceID;
}

- (void)playSoundFromBuffer:(ALuint)bufferID ToSource:(ALuint)sourceID
{
    alSourcei(sourceID, AL_BUFFER, 0);
    alSourcei(sourceID, AL_BUFFER, bufferID);
    alSourcef(sourceID, AL_PITCH, 1.0f);
    alSourcef(sourceID, AL_GAIN, 1.0f);
    alSourcePlay(sourceID);
}

-(void)dealloc
{
    [self releaseAllResources];
}

@end
