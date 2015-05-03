//
//  ZNavigationScene.m
//  Zen2D
//
//  Created by Roger Cheng on 7/26/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZNavigationScene.h"

@implementation ZNavigationScene


- (id)init
{
    if((self = [super init]))
    {
        _isActive = NO;
    }
    return self;
}


- (void)pushScene:(ZScene *)newScene
{
    if(!_stackScenes.empty())
    {
        //Turn off the current scene for the new scene
        ZScene* currentScene = (__bridge ZScene*)_stackScenes.back();
        //When a new scene is pushed the old scene always pauses (regardless of the activeness of this scene)
        [currentScene deactivateNodes];
        currentScene.isActive = NO;
    }
    newScene.parentScene = self;
    //Does the same things as the scene manager
    newScene.isActive = _isActive;
    if(_isActive)
    {
        [newScene activateNodes];
    }
    else
    {
        [newScene deactivateNodes];
    }
    _stackScenes.push_back((__bridge_retained CFTypeRef)newScene);
}

- (ZScene*)popScene
{
    ZScene* poppedScene = (__bridge_transfer ZScene*)_stackScenes.back();
    [poppedScene deactivateNodes];
    poppedScene.isActive = NO;
    poppedScene.parentScene = nil;
    _stackScenes.pop_back();
    if(!_stackScenes.empty())
    {
        ZScene* currentScene = (__bridge ZScene*)_stackScenes.back();
        currentScene.isActive = _isActive;
        if(_isActive)
        {
            [currentScene activateNodes];
        }
    }
    return poppedScene;
}

-(void)attachNode:(id)node
{
    //Disallow
}
-(void)removeNode:(id)node
{
    //Disallow
}
-(void)addRenderable:(id)renderable
{
    //Disallow
}
-(ZNode*)findNodeByIdentifier:(NSString*)identifier;
{
    //Disallow
    return nil;
}
- (ZScene *)findSceneByName:(NSString *)identifier
{
    //Disallow
    return nil;
}

//Overriding
- (void)render
{
    if(!_stackScenes.empty())
    {
        ZScene* currentScene = (__bridge ZScene*)_stackScenes.back();
        [currentScene render];
    }
}

//Overriding
- (void)updateWithTime:(float)deltaTime
{
    if(!_stackScenes.empty())
    {
        ZScene* currentScene = (__bridge ZScene*)_stackScenes.back();
        [currentScene updateWithTime:deltaTime];
    }
}

- (void)deactivateNodes
{
    if(!_stackScenes.empty())
    {
        ZScene* currentScene = (__bridge ZScene*)_stackScenes.back();
        [currentScene deactivateNodes];
    }
}

- (void)activateNodes
{
    if(!_stackScenes.empty())
    {
        ZScene* currentScene = (__bridge ZScene*)_stackScenes.back();
        [currentScene activateNodes];
    }
}

-(void)setIsActive:(BOOL)isActive
{
    _isActive = isActive;
    if(!_stackScenes.empty())
    {
        ZScene* currentScene = (__bridge ZScene*)_stackScenes.back();
        currentScene.isActive = isActive;
    }
}

- (void)dealloc
{
    for(auto scene : _stackScenes)
    {
        CFBridgingRelease(scene);
    }
    _stackScenes.clear();
}

@end
