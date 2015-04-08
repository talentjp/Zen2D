//
//  TTGCompositeScene.h
//  Zen2D
//
//  Created by Roger Cheng on 10/12/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGScene.h"

@interface TTGCompositeScene : TTGScene
{
    NSMutableArray* _arrayScenes;
    BOOL _isActive;
}

- (id)initWithScenes:(TTGScene*)firstScene, ...;
- (void)addScene:(TTGScene*)newScene;
- (void)removeSceneNamed:(NSString*)sceneName;
- (void)removeSceneAt:(int)index;
- (void)removeAllScenes;

@end
