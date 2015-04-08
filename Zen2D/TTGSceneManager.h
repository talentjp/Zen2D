//
//  TTGSceneManager.h
//  Zen2D
//
//  Created by Roger Cheng on 7/11/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TTGScene;

@interface TTGSceneManager : NSObject
{
    NSMutableArray* _arrayStoredScenes;
}
@property (strong) TTGScene* mainScene;
@property (assign) float timeTilSwitch;
@property (strong) TTGScene* incomingScene;

+ (TTGSceneManager*) sharedManager;
- (void) switchToScene:(TTGScene*)scene;
- (void) switchToScene:(TTGScene*)scene After:(float)duration;
- (void) switchToSceneNamed:(NSString*)identifier;
- (void) switchToSceneNamed:(NSString*)identifier After:(float)duration;
- (void) updateWithTime:(float)deltaTime;
- (void) renderScene;
- (void) storeScene:(TTGScene*)scene; //Provides permanent storage for scenes
- (void) removeScene:(TTGScene*)scene;
- (void) removeSceneNamed:(NSString*)identifier;
- (TTGScene*)findSceneByName:(NSString*)identifier;

@end
