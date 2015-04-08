//
//  TTGSpriteAnimation.h
//  Zen2D
//
//  Created by Roger Cheng on 5/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTGSprite.h"

//Sprite animation is actually nothing but a collection of sprites, with info of when to play each of them
//Note in current implementation one shouldn't attach a sprite to the Animation(maybe override the attachSprite method?)
@interface TTGSpriteAnimation : TTGSprite
@property (strong) NSMutableDictionary* dictAnimations; //<Key>: animation name <Value>: [duration, sprite idx 0, sprite idx 1...]
@property (assign) float timeElapsed;
@property (assign) int   activeSprite; //The sprite that's NOT hidden
@property (strong) NSString* currentAnimationName;
@property (assign) int  currentAnimationIndex;
@property (assign) BOOL isAnimationLooped;

- (void) loadSpritesFromFilenames:(NSString*) firstFile, ...;
- (void) loadSpritesFromArrayOfFiles:(NSArray*) arrayFiles;
- (void) setActiveSpriteByIndex:(int)index;
- (void) defineAnimationNamed:(NSString *)name OfDuration:(float)secs AsSpriteIndices:(int)firstIndex, ...;
- (void) playAnimation:(NSString*)name Looped:(BOOL)isLooped;
- (BOOL) isPlaying;
- (void) stopAnimation;

@end
