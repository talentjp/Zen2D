//
//  TTGScene.h
//  Zen2D
//
//  Created by Roger Cheng on 4/24/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class TTGNode;
@class TTGCamera;

@interface TTGScene : NSObject
{
    NSMutableArray* _arrayRenderables;
}

@property (assign) int screenWidth;
@property (assign) int screenHeight;
@property (strong) NSMutableArray* arrayChildren;
@property (strong) TTGCamera* activeCamera;
@property (strong) GLKBaseEffect* effect;
@property (assign) BOOL isActive;
@property (copy)   NSString* identifier;
@property (weak)   TTGScene* parentScene;

-(id)initWithWidth:(int)width Height:(int)height;
-(void)attachNode:(id)node;
-(void)removeNode:(id)node;
-(void)destroyAllNodes;
-(void)render;
-(void)updateWithTime:(float) deltaTime;
-(void)addRenderable:(id)renderable;
-(TTGNode*)findNodeByIdentifier:(NSString*)identifier;
-(void)deactivateNodes;
-(void)activateNodes;
- (TTGScene*)findSceneByName:(NSString*)identifier;

@end
