//
//  ZNode.m
//  Zen2D
//
//  Created by Roger Cheng on 5/27/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZNode.h"
#import "ZTouchComponent.h"
#import "ZScene.h"
#import "ZAnimator.h"
#import "ZComponent.h"
#import "ZSprite.h"

@implementation ZNode
@synthesize effect = _effect;
@synthesize arrayChildren = _arrayChildren;
@synthesize spritePosition = _spritePosition;
@synthesize rotation = _rotation;
@synthesize parentNode = _parentNode;
@synthesize arrayComponents = _arrayComponents;
@synthesize timeSinceLastFrame = _timeSinceLastFrame;
@synthesize scale = _scale;
@synthesize hide = _hide;
@synthesize identifier = _identifier;
@synthesize parentScene = _parentScene;
@synthesize delayedKill = _delayedKill;
@synthesize opacity = _opacity;
@synthesize brightness = _brightness;
@synthesize touchMode = _touchMode;

- (id)init
{
    if((self = [super init]))
    {
        _modelViewMat = GLKMatrix4Identity;
        _opacity = 1.0;
        _brightness = 1.0;
        _delayedKill = NO;
        _parentScene = nil;
        _parentNode = nil;
        _identifier = @"";
        _hide = NO;
        _scale = CGSizeMake(1.0, 1.0);
        _rotation = 0;
        _arrayChildren = [NSMutableArray array];
        _arrayComponents = [NSMutableArray array];
        _arrayAnimators = [NSMutableArray array];
        _spritePosition = CGPointMake(0, 0);
        _effect = nil; //Effect is passed from the parent sprite to the child sprite.
        _touchMode = TOUCH_MODE_ALL; //There is no telling if a touch falls inside a node
    }
    return self;
}

- (void)attachNode:(ZNode *)node
{
    [_arrayChildren addObject:node];
    [node passEffect:self.effect];
    node.parentNode = self;
    node.parentScene = self.parentScene;
    if(_parentScene)
    {
        if(_parentScene.isActive)
        {
            [node activateComponents];
            [node activateNodes];
        }
    }
}

- (void)removeNode:(id)node
{
    [_arrayChildren removeObject:node];
}

- (void)passModelViewMatrix:(GLKMatrix4)mat
{
    //To eliminate the flickering issue, we can only draw sprite on pixels
    _modelViewMat = GLKMatrix4Translate(mat, (int)_spritePosition.x, (int)_spritePosition.y, 0);
    _modelViewMat = GLKMatrix4RotateZ(_modelViewMat, GLKMathDegreesToRadians(_rotation));
    _modelViewMat = GLKMatrix4Scale(_modelViewMat, _scale.width, _scale.height, 1.0);
    
    for(ZNode* node in _arrayChildren)
    {
        [node passModelViewMatrix:_modelViewMat];
    }
}

- (void)passEffect:(GLKBaseEffect *)effect
{
    self.effect = effect;
    for(ZNode* node in _arrayChildren)
    {
        [node passEffect:effect];
    }
}

- (void)destroy
{
    //Clean up all components (pointer to parent and other resources)
    for (id component in _arrayComponents)
    {
        [component cleanup];
    }
    [_arrayComponents removeAllObjects];

    //Check the logic here
    NSMutableArray* discardedObjects = [NSMutableArray arrayWithArray:_arrayChildren];
    
    for(id obj in discardedObjects)
    {
        [obj destroy];
    }
    [_arrayChildren removeAllObjects];
    //Remove node from parent's child array
    [_parentNode removeNode:self];
    
    //Remove all animators from node
    [_arrayAnimators removeAllObjects];
}

- (BOOL)isLocationWithinSprite:(CGPoint)location
{
    //Sprite is invisible
    return NO;
}

- (void)addComponent:(ZComponent*)component
{
    [_arrayComponents addObject:component];
    component.parentNode = self;
    [component attachedToNode];
    if(_parentScene)
    {
        if(_parentScene.isActive)
        {
            [component activate];
        }
    }
}

- (ZNode*)addAnimator:(ZAnimator *)animator
{
    //Should we remove duplicate animator?Or simply allow the users to do anything?
    //[self removeAnimatorOfClass:[animator class]];
    [_arrayAnimators addObject:animator];
    [animator initializeWithNode:self];
    return self;
}

- (void)removeAnimatorOfClass:(Class)cls
{
    ZAnimator* animatorToRemove = nil;
    for(ZAnimator* animator in _arrayAnimators)
    {
        if([animator isKindOfClass:cls])
        {
            animatorToRemove = animator;
            break;
        }
    }
    if(animatorToRemove)
    {
        [_arrayAnimators removeObject:animatorToRemove];
    }
}

- (void)removeFinishedAnimators
{
    NSMutableArray* arrayOfFinished = [NSMutableArray array];
    for(ZAnimator* animator in _arrayAnimators)
    {
        if(animator.isFinished)
        {
            [arrayOfFinished addObject:animator];
        }
    }
    [_arrayAnimators removeObjectsInArray:arrayOfFinished];
}

- (id)findComponentByClass:(Class)theClass
{
    for(id component in _arrayComponents)
    {
        if([component isKindOfClass:theClass])
        {
            return component;
        }
    }
    
    return nil;
}

- (void)addNodeToSceneForRender:(ZScene *)scene
{
    if(!self.hide)
    {
        if([self isKindOfClass:[ZSprite class]])
            [scene addRenderable:self];
        
        for(ZNode* node in _arrayChildren)
        {
            [node addNodeToSceneForRender:scene];
        }
    }
}

- (ZNode *)findNodeByIdentifier:(NSString *)identifier
{
    ZNode* foundNode = nil;
    
    if([self.identifier isEqualToString:identifier])
    {
        foundNode = self;
    }
    else
    {
        for(ZNode* node in _arrayChildren)
        {
            if((foundNode = [node findNodeByIdentifier:identifier]))
            {
                break;
            }
        }
    }
    return foundNode;
}

- (void)moveToX:(float)xCoordinate Y:(float)yCoordinate
{
    _spritePosition = CGPointMake(xCoordinate, yCoordinate);
}

- (void)translateByX:(float)deltaX Y:(float)deltaY
{
    _spritePosition = CGPointMake(_spritePosition.x + deltaX, _spritePosition.y + deltaY);
}

- (void)resetComponents
{
    for(ZComponent* comp in _arrayComponents)
    {
        [comp reset];
    }
}

- (void)render
{
    
}

- (void)gameUpdate
{
    //Override this method
}

- (void)updateWithTime:(float)deltaTime
{
    _timeSinceLastFrame = deltaTime;
    
    for(id component in _arrayComponents)
    {
        [component update];
    }
    
    [self gameUpdate];
    //Animate the node, note that we have can't add or delete objects during iteration
    NSArray* tempArray = [NSArray arrayWithArray:_arrayAnimators];
    for(ZAnimator* animator in tempArray)
    {
        [animator animateForDeltaTime:deltaTime];
    }
    //Clean up finished animators
    [self removeFinishedAnimators];
    
    //Destroy the nodes that have delayed kill set
    tempArray = [NSArray arrayWithArray:_arrayChildren];
    for(ZNode* node in tempArray)
    {
        if(node.delayedKill)
        {
            [node destroy];
        }
    }
    //Update the nodes in a temporary array to protect iterator(nodes can destroy themselves)
    tempArray = [NSArray arrayWithArray:_arrayChildren];
    for(ZNode* node in tempArray)
    {
        [node updateWithTime:deltaTime];
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    ZNode* newNode = [[[self class] allocWithZone:zone] init];
    if(newNode)
    {
        //Effect is passed down from the scene
        newNode.effect = nil;
        newNode.arrayChildren = [NSMutableArray array];
        for(ZNode* node in _arrayChildren)
        {
            [newNode attachNode:[node copy]];
        }
        newNode.spritePosition = _spritePosition;
        newNode.rotation = _rotation;
        //It can be attached to any node
        newNode.parentNode = nil;
        newNode.arrayComponents = [NSMutableArray array];
        for(ZComponent* comp in _arrayComponents)
        {
            [newNode addComponent:[comp copy]];
        }
        newNode.timeSinceLastFrame = 0;
        newNode.scale = _scale;
        newNode.hide = _hide;
        //Identifier should be unique
        newNode.identifier = nil;
        //It can be attached to anything
        newNode.parentScene = nil;
        newNode.delayedKill = NO;
        newNode.opacity = _opacity;
        newNode.brightness = _brightness;
        newNode.touchMode = _touchMode;
    }
    return newNode;
}

- (void)activateComponents
{
    for(ZComponent* component in _arrayComponents)
    {
        [component activate];
    }
}

- (void)deactivateComponents
{
    for(ZComponent* component in _arrayComponents)
    {
        [component deactivate];
    }
}

- (void)activateNodes
{
    for(ZNode* node in _arrayChildren)
    {
        [node activateComponents];
        [node activateNodes];
    }
}

- (void)deactivateNodes
{
    for(ZNode* node in _arrayChildren)
    {
        [node deactivateNodes];
        [node deactivateComponents];
    }
}

- (void)stopAllAnimators
{
    for(ZAnimator* animator in _arrayAnimators)
    {
        animator.isFinished = YES;
    }
}

- (void)setParentScene:(ZScene *)parentScene
{
    _parentScene = parentScene;
    for(ZNode* node in _arrayChildren)
    {
        [node setParentScene:parentScene];
    }
}


@end
