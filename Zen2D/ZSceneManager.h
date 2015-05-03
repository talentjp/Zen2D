//
//  ZSceneManager.h
//  Zen2D
//
//  Created by Roger Cheng on 7/11/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZScene;

@interface ZSceneManager : NSObject
{
    NSMutableArray* _arrayStoredScenes;
}
@property (strong) ZScene* mainScene;
@property (assign) float timeTilSwitch;
@property (strong) ZScene* incomingScene;

+ (ZSceneManager*) sharedManager;
- (void) switchToScene:(ZScene*)scene;
- (void) switchToScene:(ZScene*)scene After:(float)duration;
- (void) switchToSceneNamed:(NSString*)identifier;
- (void) switchToSceneNamed:(NSString*)identifier After:(float)duration;
- (void) updateWithTime:(float)deltaTime;
- (void) renderScene;
- (void) storeScene:(ZScene*)scene; //Provides permanent storage for scenes
- (void) removeScene:(ZScene*)scene;
- (void) removeSceneNamed:(NSString*)identifier;
- (ZScene*)findSceneByName:(NSString*)identifier;

@end
