//
//  TTGSpriteAnimation.m
//  Zen2D
//
//  Created by Roger Cheng on 5/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGSpriteAnimation.h"

//Sprite animation is actually nothing but a collection of sprites, with info of when to play each of them
@implementation TTGSpriteAnimation
@synthesize dictAnimations = _dictAnimations;
@synthesize timeElapsed = _timeElapsed;
@synthesize activeSprite = _activeSprite;
@synthesize currentAnimationName = _currentAnimationName;
@synthesize currentAnimationIndex = _currentAnimationIndex;
@synthesize isAnimationLooped = _isAnimationLooped;

- (id)init
{
    if((self = [super init]))
    {
        self.spriteDepth = 0;
        self.hide = NO;
        self.scale = CGSizeMake(1.0, 1.0);
        self.rotation = 0;
        self.arrayChildren = [NSMutableArray array];
        self.arrayComponents = [NSMutableArray array];
        self.spritePosition = CGPointMake(0, 0);
        self.effect = nil;
        _currentAnimationName = nil;
        _currentAnimationIndex = 1;
        _isAnimationLooped = NO;
        _activeSprite = 0;
        _timeElapsed = 0;
        _dictAnimations = [NSMutableDictionary dictionary];
        self.touchMode = TOUCH_MODE_INSIDE;
    }
    return self;
}

- (void)loadSpritesFromFilenames:(NSString *)firstFile, ...
{
    NSString* eachFile;
    va_list argumentList;
    if(firstFile)
    {
        TTGSprite* newSprite = [[TTGSprite alloc] initWithFile:firstFile];
        [self attachNode:newSprite];
        va_start(argumentList, firstFile);
        while((eachFile = va_arg(argumentList, NSString*)))
        {
            newSprite = [[TTGSprite alloc] initWithFile:eachFile];
            [self attachNode:newSprite];
        }
        va_end(argumentList);
        
        [self setActiveSpriteByIndex:0];
    }
}

- (void)loadSpritesFromArrayOfFiles:(NSArray *)arrayFiles
{
    if(arrayFiles)
    {
        for(NSString* filename in arrayFiles)
        {
            TTGSprite* newSprite = [[TTGSprite alloc] initWithFile:filename];
            [self attachNode:newSprite];
        }
        [self setActiveSpriteByIndex:0];
    }
}

- (void)setActiveSpriteByIndex:(int)index
{
    for(TTGSprite* sprite in self.arrayChildren)
    {
        sprite.hide = YES;
    }
    
    TTGSprite* activeSprite = [self.arrayChildren objectAtIndex:index];
    activeSprite.hide = NO;
    self.spriteSize = activeSprite.spriteSize;
}

- (void)defineAnimationNamed:(NSString *)name OfDuration:(float)secs AsSpriteIndices:(int)firstIndex, ...
{
    int eachIndex;
    va_list argumentList;
    NSMutableArray* newArray = [NSMutableArray arrayWithObject:[NSNumber numberWithFloat:secs]];
    [newArray addObject:[NSNumber numberWithInt:firstIndex]];
    va_start(argumentList, firstIndex);
    while((eachIndex = va_arg(argumentList, int)))
    {
        [newArray addObject:[NSNumber numberWithInt:eachIndex]];
    }
    va_end(argumentList);
    
    [_dictAnimations setObject:newArray forKey:name];
    NSLog(@"The Animation Dictionary : %@", _dictAnimations);
}


- (BOOL)isLocationWithinSprite:(CGPoint)location
{
    //May have to determine hit based on camera
    
    //Easiest approach, simply inverse transform the touch point with the current model view matrix and compare
    GLKVector4 touchPoint = GLKVector4Make(location.x, location.y, 0, 1);
    GLKVector4 trans_touch = GLKMatrix4MultiplyVector4(GLKMatrix4Invert(_modelViewMat, nil), touchPoint);
    //Reject immediately if it falls outside the sprite
    if(trans_touch.x > self.spriteSize.width / 2.0 || trans_touch.x < -self.spriteSize.width / 2.0 ||
       trans_touch.y > self.spriteSize.height / 2.0 || trans_touch.y < -self.spriteSize.height / 2.0)
    {
        return NO;
    }
    
    return YES;
}

- (void)render
{
    //Do nothing here as we don't want to render the "container"
}

- (void)gameUpdate
{
    //Override this method
}

- (void)updateWithTime:(float)deltaTime
{
    self.timeSinceLastFrame = deltaTime;
    //Switch sprites only when there is an active animation
    if(_currentAnimationName)
    {
        _timeElapsed += self.timeSinceLastFrame;
        float duration = [[[_dictAnimations objectForKey:_currentAnimationName] objectAtIndex:0] floatValue];
        uint32_t countSprites = (uint32_t)[((NSMutableArray*)[_dictAnimations objectForKey:_currentAnimationName]) count] - 1;
        float timeToSwitch = countSprites == 1 ? 0 : duration / (countSprites - 1);
        if(_timeElapsed > timeToSwitch)
        {
            if(_currentAnimationIndex == countSprites) //Last sprite to play
            {
                if(_isAnimationLooped)
                {
                    _currentAnimationIndex = 1; //Loops back to the first sprite
                }
                else
                {
                    _currentAnimationName = nil; //Animation finished
                }
            }
            else
            {
                _currentAnimationIndex++;
            }
            
            if(_currentAnimationName)
            {
                _activeSprite = [[[_dictAnimations objectForKey:_currentAnimationName] objectAtIndex:_currentAnimationIndex] intValue];
                [self setActiveSpriteByIndex:_activeSprite];
            }
            _timeElapsed = 0;
        }
    }
    
    [self gameUpdate];
    for(TTGSprite* sprite in self.arrayChildren)
    {
        [sprite updateWithTime:deltaTime];
    }
}

- (void)playAnimation:(NSString *)name Looped:(BOOL)isLooped
{
    if([_dictAnimations objectForKey:name])
    {
        _currentAnimationName = name;
        _isAnimationLooped = isLooped;
        _currentAnimationIndex = 1;
        _timeElapsed = 0;
        [self setActiveSpriteByIndex:[[[_dictAnimations objectForKey:name] objectAtIndex:1] intValue]];
    }
}

- (BOOL)isPlaying
{
    if(_currentAnimationName)
    {
        return YES;
    }
    
    return NO;
}

- (void)stopAnimation
{
    _currentAnimationName = nil;
    _timeElapsed = 0;
}

- (void)setSpriteDepth:(float)spriteDepth
{
    super.spriteDepth = spriteDepth;
    for(TTGSprite* sprite in self.arrayChildren)
    {
        sprite.spriteDepth = spriteDepth;
    }
}

@end
