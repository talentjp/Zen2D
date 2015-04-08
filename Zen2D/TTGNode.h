//
//  TTGNode.h
//  Zen2D
//
//  Created by Roger Cheng on 5/27/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class TTGScene;
@class TTGAnimator;

typedef enum{
    TOUCH_MODE_ALL = 0,
    TOUCH_MODE_INSIDE
}DefaultTouchMode;

@interface TTGNode : NSObject <NSCopying>
{
    GLKMatrix4 _modelViewMat;
}

@property (strong) GLKBaseEffect*  effect;
@property (strong) NSMutableArray* arrayChildren;
@property (assign) CGPoint         spritePosition;
@property (assign) float           rotation; //In degrees
@property (weak)   id              parentNode; //It will complicate the release of parent object if this is not weak
@property (strong) NSMutableArray* arrayComponents;
@property (assign) float           timeSinceLastFrame;
@property (assign) CGSize          scale;
@property (assign) BOOL            hide;
@property (copy)   NSString*       identifier;
@property (nonatomic, weak)        TTGScene* parentScene;
@property (assign) BOOL            delayedKill;
@property (strong) NSMutableArray* arrayAnimators;
@property (assign) float           opacity;
@property (assign) float           brightness;
@property (assign) DefaultTouchMode touchMode;

- (void)render;
- (void)updateWithTime:(float) deltaTime;
- (void)attachNode:(TTGNode*) node;
- (void)removeNode:(id) node;
- (void)passModelViewMatrix:(GLKMatrix4)mat;
- (void)passEffect:(GLKBaseEffect*) effect;
- (void)destroy;
- (void)addComponent:(id) component;
- (TTGNode*)addAnimator:(TTGAnimator*) animator;
- (void)removeAnimatorOfClass:(Class) cls;
- (void)removeFinishedAnimators;
- (void)gameUpdate;
- (BOOL)isLocationWithinSprite:(CGPoint)location;
- (id)findComponentByClass:(Class)theClass;
- (void)addNodeToSceneForRender:(TTGScene*)scene; //Adds itself and its children recursively to scene for ordering by depth during each draw
- (TTGNode*)findNodeByIdentifier:(NSString*)identifier;
- (void)moveToX:(float)xCoordinate Y:(float)yCoordinate;
- (void)translateByX:(float)deltaX Y:(float)deltaY;
- (void)activateComponents;
- (void)deactivateComponents;
- (void)activateNodes;
- (void)deactivateNodes;
- (void)resetComponents;
- (void)stopAllAnimators;
- (void)setParentScene:(TTGScene *)parentScene;

@end
