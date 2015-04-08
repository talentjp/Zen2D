//
//  TTGScene.m
//  Zen2D
//
//  Created by Roger Cheng on 4/24/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGScene.h"
#import "TTGSprite.h"
#import "TTGTouchManager.h"
#import "TTGCamera.h"
#import "TTGScale.h"

@implementation TTGScene
@synthesize arrayChildren = _arrayChildren;
@synthesize activeCamera  = _activeCamera;
@synthesize effect = _effect;
@synthesize isActive = _isActive;
@synthesize screenWidth = _screenWidth;
@synthesize screenHeight = _screenHeight;
@synthesize identifier = _identifier;
@synthesize parentScene = _parentScene;


- (id)initWithWidth:(int)width Height:(int)height
{
    if((self = [super init]))
    {
        _parentScene = nil;
        _isActive = NO;
        _arrayRenderables = [NSMutableArray array];
        _screenWidth = width;
        _screenHeight = height;
        _arrayChildren = [NSMutableArray array];
        TTGCamera* defaultCamera = [[TTGCamera alloc] initWithWidth:width Height:height];
        _activeCamera = defaultCamera;
        self.effect = [[GLKBaseEffect alloc] init];
        //default effect across all nodes
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, width, 0, height, -1024, 1024);
        self.effect.transform.projectionMatrix = projectionMatrix;
    }
    return self;
}

- (void)attachNode:(TTGNode*)node
{
    [self.arrayChildren addObject:node];
    [node passEffect:self.effect];
    [node setParentNode:self];
    node.parentScene = self;
    if(_isActive)
    {
        [node activateComponents];
        [node activateNodes];
    }
}

- (void)removeNode:(TTGNode*)node
{
    [self.arrayChildren removeObject:node];
}

- (void)destroyAllNodes
{    
    NSArray* tempArray = [NSArray arrayWithArray:self.arrayChildren];
    for(TTGNode* node in tempArray)
    {
        [node destroy];
    }
}

- (void)addRenderable:(id)renderable
{
    [_arrayRenderables addObject:renderable];
}

- (void)render
{
    for(TTGNode* node in _arrayChildren)
    {
        [node addNodeToSceneForRender:self];
    }
    //Beware! this can be a performance bottleneck, try not to sort the objects too often.
    //Maybe objects of the same group should have the same depth?
    NSArray* sortedArray = [_arrayRenderables sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        TTGSprite* sprite1 = obj1;
        TTGSprite* sprite2 = obj2;
        if(sprite1.spriteDepth > sprite2.spriteDepth)
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        else if(sprite1.spriteDepth < sprite2.spriteDepth)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else
        {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    //Could pass camera parameters here
    //Pay attention to the modified touch location
    for(TTGNode* node in _arrayChildren)
    {
        //Think about how everything can be passed at once
        [node passModelViewMatrix:[_activeCamera getCameraMatrix]];
    }
    for(id node in sortedArray)
    {
        [node render];
    }
    
    [_arrayRenderables removeAllObjects];
    //Re-sort the order of touch components in touch manager
    [[TTGTouchManager sharedManager] recalculateSortedComponents];
}

- (TTGNode *)findNodeByIdentifier:(NSString *)identifier
{
    for(TTGNode* node in _arrayChildren)
    {
        TTGNode* foundNode;
        if((foundNode = [node findNodeByIdentifier:identifier]))
        {
            return foundNode;
        }
    }
    return nil;
}

- (void)activateNodes
{
    for(TTGNode* node in _arrayChildren)
    {
        [node activateComponents];
        [node activateNodes];
    }
}

- (void)deactivateNodes
{
    for(TTGNode* node in _arrayChildren)
    {
        [node deactivateNodes];
        [node deactivateComponents];
    }
}

-(void)updateWithTime:(float)deltaTime
{
    //Destroy the nodes that have delayed kill set
    NSArray* tempArray = [NSArray arrayWithArray:_arrayChildren];
    for(TTGNode* node in tempArray)
    {
        if(node.delayedKill)
        {
            [node destroy];
        }
    }
    //Update the nodes in a temporary array to protect iterator(nodes can destroy themselves)
    if(_isActive)
    {
        tempArray = [NSArray arrayWithArray:_arrayChildren];
        for(TTGNode* node in tempArray)
        {
            [node updateWithTime:deltaTime];
        }
        [_activeCamera updateWithTime:deltaTime];
    }
}

- (TTGScene *)findSceneByName:(NSString *)identifier
{
    if([identifier isEqualToString:self.identifier])
    {
        return self;
    }
    return nil;
}

- (void)dealloc
{
    NSArray* tempArray = [NSArray arrayWithArray:_arrayChildren];
    //Clean up all the nodes before destruction
    for(TTGNode* node in tempArray)
    {
        [node destroy];
    }
    [_arrayChildren removeAllObjects];
}


@end
