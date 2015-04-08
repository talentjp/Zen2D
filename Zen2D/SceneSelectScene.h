//
//  SceneSelectScene.h
//  Zen2D
//
//  Created by Roger Cheng on 10/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGScene.h"

@class TouchableText;

@interface SceneSelectScene : TTGScene
{
    NSArray* _titleScenes;
    NSArray* _arrayScenes;
    uint32_t _currentSceneIndex;
    TouchableText* _currentText;
}

- (void) nextScene;
- (void) prevScene;
- (void) enterScene;

@end
