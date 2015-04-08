//
//  TTGCompositeScene.m
//  Zen2D
//
//  Created by Roger Cheng on 10/12/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGCompositeScene.h"

@implementation TTGCompositeScene

- (id)init
{
    if((self = [super init]))
    {
        _arrayScenes = [NSMutableArray array];
        _isActive = NO;
    }
    return self;
}


- (id)initWithScenes:(TTGScene *)firstScene, ...
{
    
    if((self = [self init]))
    {
        TTGScene* eachScene;
        va_list argumentList;
        //Attach first scene here
        if(firstScene)
        {
            [self addScene:firstScene];
        }
        va_start(argumentList, firstScene);
        while((eachScene = va_arg(argumentList, TTGScene*)))
        {
            [self addScene:eachScene];
        }
        va_end(argumentList);
    }
    return self;
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

- (void)addScene:(TTGScene *)newScene
{
    newScene.parentScene = self;
    newScene.isActive = _isActive;
    if(_isActive)
    {
        [newScene activateNodes];
    }
    [_arrayScenes addObject:newScene];
}

- (void)removeAllScenes
{
    for(TTGScene* scene in _arrayScenes)
    {
        scene.parentScene = nil;
        [scene deactivateNodes];
        scene.isActive = NO;
    }
    [_arrayScenes removeAllObjects];
}

- (void)removeSceneAt:(int)index
{
    if(index < [_arrayScenes count] && index >= 0)
    {
        [[_arrayScenes objectAtIndex:index] setParentScene:nil];
        [[_arrayScenes objectAtIndex:index] deactivateNodes];
        [[_arrayScenes objectAtIndex:index] setIsActive:NO];
        [_arrayScenes removeObjectAtIndex:index];
    }
    else
    {
        NSLog(@"[Warning]Out-of-bound index is passed to removeSceneAt");
    }
}

- (void)removeSceneNamed:(NSString *)sceneName
{
    TTGScene* sceneToRemove;
    for(TTGScene* scene in _arrayScenes)
    {
        if([sceneName isEqualToString:scene.identifier])
        {
            sceneToRemove = scene;
            sceneToRemove.parentScene = nil;
            [sceneToRemove deactivateNodes];
            sceneToRemove.isActive = NO;
            break;
        }
    }
    [_arrayScenes removeObject:sceneToRemove];
}

- (TTGScene *)findSceneByName:(NSString *)sceneName
{
    for(TTGScene* scene in _arrayScenes)
    {
        if([sceneName isEqualToString:scene.identifier])
        {
            return scene;
        }
    }
    return nil;
}

- (void)render
{
    for(TTGScene* scene in _arrayScenes)
    {
        [scene render];
    }
}

- (void)updateWithTime:(float)deltaTime
{
    for(TTGScene* scene in _arrayScenes)
    {
        [scene updateWithTime:deltaTime];
    }
}

- (void)deactivateNodes
{
    for(TTGScene* scene in _arrayScenes)
    {
        [scene deactivateNodes];
    }
}

- (void)activateNodes
{
    for(TTGScene* scene in _arrayScenes)
    {
        [scene activateNodes];
    }
}

-(void)setIsActive:(BOOL)isActive
{
    _isActive = isActive;
    for(TTGScene* scene in _arrayScenes)
    {
        scene.isActive = isActive;
    }
}

@end
