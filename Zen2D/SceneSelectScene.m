//
//  SceneSelectScene.m
//  Zen2D
//
//  Created by Roger Cheng on 10/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "SceneSelectScene.h"
#import "ZDeviceManager.h"
#import "ZSceneManager.h"
#import "ArrowSprite.h"
#import "DemoCompositeScene.h"
#import "DemoTextAnimation.h"
#import "DemoBasicScene.h"
#import "DemoPhysicsScene.h"
#import "DemoTetris.h"
#import "DemoSpriteAnimation.h"
#import "TouchableText.h"


@implementation SceneSelectScene

- (id)init
{
    float width = [[ZDeviceManager sharedManager] getScreenWidth];
    float height = [[ZDeviceManager sharedManager] getScreenHeight];;
    
    if((self = [super initWithWidth:width Height:height]))
    {
        _currentSceneIndex = 0;
        _titleScenes = @[@"Basic", @"Composite Scenes", @"Text Animation", @"Sprite Animation", @"Physics", @"Tetris"];
        _arrayScenes = @[[[DemoBasicScene alloc] init],[[DemoCompositeScene alloc] init],[[DemoTextAnimation alloc] init],[[DemoSpriteAnimation alloc] init],
                         [[DemoPhysicsScene alloc] init], [[DemoTetris alloc] init]];
        
        _currentText = [[TouchableText alloc] initWithString:[_titleScenes objectAtIndex:0]];
        [self attachNode:_currentText];
        _currentText.scale = CGSizeMake(1.5, 1.5);
        [_currentText moveToX:width/2 Y:height/2];
        
        ArrowSprite* rightArrow = [[ArrowSprite alloc] init];
        [self attachNode:rightArrow];
        [rightArrow moveToX:width/2 + 175 Y:height/2];
        rightArrow.identifier = @"RightArrow";
        
        ArrowSprite* leftArrow = [[ArrowSprite alloc] init];
        [self attachNode:leftArrow];
        leftArrow.rotation = 180;
        [leftArrow moveToX:width/2 - 175 Y:height/2];
        leftArrow.identifier = @"LeftArrow";
    }
    return self;
}

- (void)nextScene
{
    _currentSceneIndex = (_currentSceneIndex + 1) % [_titleScenes count];
    [_currentText setText:[_titleScenes objectAtIndex:_currentSceneIndex]];
}

- (void)prevScene
{
    _currentSceneIndex = (uint32_t)((_currentSceneIndex + [_titleScenes count] - 1) % [_titleScenes count]);
    [_currentText setText:[_titleScenes objectAtIndex:_currentSceneIndex]];
}

- (void)enterScene
{
    [[ZSceneManager sharedManager] switchToScene:[_arrayScenes objectAtIndex:_currentSceneIndex]];
}

@end
