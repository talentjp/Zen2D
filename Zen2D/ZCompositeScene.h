//
//  ZCompositeScene.h
//  Zen2D
//
//  Created by Roger Cheng on 10/12/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZScene.h"

@interface ZCompositeScene : ZScene
{
    NSMutableArray* _arrayScenes;
    BOOL _isActive;
}

- (id)initWithScenes:(ZScene*)firstScene, ...;
- (void)addScene:(ZScene*)newScene;
- (void)removeSceneNamed:(NSString*)sceneName;
- (void)removeSceneAt:(int)index;
- (void)removeAllScenes;

@end
