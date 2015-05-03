//
//  DemoCompositeScene.m
//  Zen2D
//
//  Created by Roger Cheng on 10/13/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoCompositeScene.h"
#import "ZDeviceManager.h"
#import "ZCamera.h"
#import "ZScale.h"
#import "ZShake.h"
#import "ZRotate.h"
#import "ZTrigger.h"
#import "ZSceneManager.h"
#import "ZSprite.h"
#import "ReturnSprite.h"

@implementation DemoCompositeScene

- (id)init
{
    if((self = [super init]))
    {
        float width = [[ZDeviceManager sharedManager] getScreenWidth];
        float height = [[ZDeviceManager sharedManager] getScreenHeight];
        ZScene* testScene = [[ZScene alloc] initWithWidth:width Height:height];
        [self addScene:testScene];
        testScene.identifier = @"TestScene1";
        ZCamera* newCamera = [[ZCamera alloc] init];
        [newCamera translateByX:0 Y:0];
        newCamera.scale = CGSizeMake(0.5, 0.5);
        newCamera.rotation = 0;
        [newCamera addAnimator:[ZRotate rotateBy:360 During:5]];
        [newCamera addAnimator:[ZScale scaleToWidth:2.5 Height:2.5 During:10]];
        testScene.activeCamera = newCamera;
        ZScene* testScene2 = [[ZScene alloc] initWithWidth:width Height:height];
        [self addScene:testScene2];
        testScene2.identifier = @"TestScene2";
        ZCamera* newCamera2 = [[ZCamera alloc] init];
        ZTrigger* trigger = [ZTrigger triggerAnimator:[ZShake shakeWithinDistance:30 During:1] After:2];
        [newCamera2 addAnimator:trigger];
        testScene2.activeCamera = newCamera2;
        //Basic rendering test
        ZSprite* space = [[ZSprite alloc] initWithFile:@"space.jpg"];
        ZNode* mainNode = [[ZNode alloc] init];
        [mainNode attachNode:space];
        [testScene attachNode:mainNode];
        [mainNode moveToX:width/2.0 Y:height/2.0];
        ZSprite* cockpit = [[ZSprite alloc] initWithFile:@"cockpit.png"];
        cockpit.scale = CGSizeMake(1.5, 1);
        [cockpit moveToX:width/2.0 Y:height/2.0];
        [testScene2 attachNode:cockpit];
        [testScene2 attachNode:[[ReturnSprite alloc] init]];
    }
    return self;
}

@end
