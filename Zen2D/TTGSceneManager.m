//
//  TTGSceneManager.m
//  Zen2D
//
//  Created by Roger Cheng on 7/11/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGSceneManager.h"
#import "TTGScene.h"

static TTGSceneManager* singleton = nil;

@implementation TTGSceneManager
@synthesize mainScene = _mainScene;
@synthesize incomingScene = _incomingScene;
@synthesize timeTilSwitch = _timeTilSwitch;

+ (TTGSceneManager *)sharedManager
{
    @synchronized(singleton)
    {
        if(!singleton)
        {
            singleton = [[TTGSceneManager alloc] init];
        }
    }
    return singleton;
}

- (id)init
{
    if((self = [super init]))
    {
        _arrayStoredScenes = [NSMutableArray array];
        singleton = self;
        _timeTilSwitch = 0;
        _incomingScene = nil;
        _mainScene = nil;
    }
    return singleton;
}

- (void)switchToScene:(TTGScene *)scene
{
    if(scene)
    {    
        if(_mainScene)
        {
            _mainScene.isActive = NO;
            [_mainScene deactivateNodes];
        }
        _mainScene = scene;
        _mainScene.isActive = YES;
        [_mainScene activateNodes];
    }
}

- (void)switchToScene:(TTGScene *)scene After:(float)duration
{
    if(scene)
    {
        _incomingScene = scene;
        _timeTilSwitch = duration;
    }
}

- (void)switchToSceneNamed:(NSString *)identifier
{
    [self switchToScene:[self findSceneByName:identifier]];
}

- (void)switchToSceneNamed:(NSString *)identifier After:(float)duration
{
    [self switchToScene:[self findSceneByName:identifier] After:duration];
}

- (void)updateWithTime:(float)deltaTime
{
    if(_incomingScene)
    {
        _timeTilSwitch -= deltaTime;
        if(_timeTilSwitch <= 0)
        {
            [self switchToScene:_incomingScene];
            _incomingScene = nil;
            _timeTilSwitch = 0;
        }
    }
    [_mainScene updateWithTime:deltaTime];
}

- (void)renderScene
{
    [_mainScene render];
}

- (void)storeScene:(TTGScene *)scene
{
    [_arrayStoredScenes addObject:scene];
}

- (void)removeScene:(TTGScene *)scene
{
    [_arrayStoredScenes removeObject:scene];
}

- (void)removeSceneNamed:(NSString *)identifier
{
    [_arrayStoredScenes removeObject:[self findSceneByName:identifier]];
}

- (TTGScene *)findSceneByName:(NSString *)identifier
{
    for(TTGScene* scene in _arrayStoredScenes)
    {
        if([scene.identifier isEqualToString:identifier])
        {
            return scene;
        }
    }
    return nil;
}

@end
