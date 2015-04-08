//
//  DemoCompositeScene.m
//  Zen2D
//
//  Created by Roger Cheng on 10/13/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoCompositeScene.h"
#import "TTGDeviceManager.h"
#import "TTGCamera.h"
#import "TTGScale.h"
#import "TTGShake.h"
#import "TTGRotate.h"
#import "TTGTrigger.h"
#import "TTGSceneManager.h"
#import "TTGSprite.h"
#import "ReturnSprite.h"

@implementation DemoCompositeScene

- (id)init
{
    if((self = [super init]))
    {
        float width = [[TTGDeviceManager sharedManager] getScreenWidth];
        float height = [[TTGDeviceManager sharedManager] getScreenHeight];
        TTGScene* testScene = [[TTGScene alloc] initWithWidth:width Height:height];
        [self addScene:testScene];
        testScene.identifier = @"TestScene1";
        TTGCamera* newCamera = [[TTGCamera alloc] init];
        [newCamera translateByX:0 Y:0];
        newCamera.scale = CGSizeMake(0.5, 0.5);
        newCamera.rotation = 0;
        [newCamera addAnimator:[TTGRotate rotateBy:360 During:5]];
        [newCamera addAnimator:[TTGScale scaleToWidth:2.5 Height:2.5 During:10]];
        testScene.activeCamera = newCamera;
        TTGScene* testScene2 = [[TTGScene alloc] initWithWidth:width Height:height];
        [self addScene:testScene2];
        testScene2.identifier = @"TestScene2";
        TTGCamera* newCamera2 = [[TTGCamera alloc] init];
        TTGTrigger* trigger = [TTGTrigger triggerAnimator:[TTGShake shakeWithinDistance:30 During:1] After:2];
        [newCamera2 addAnimator:trigger];
        testScene2.activeCamera = newCamera2;
        //Basic rendering test
        TTGSprite* space = [[TTGSprite alloc] initWithFile:@"space.jpg"];
        TTGNode* mainNode = [[TTGNode alloc] init];
        [mainNode attachNode:space];
        [testScene attachNode:mainNode];
        [mainNode moveToX:width/2.0 Y:height/2.0];
        TTGSprite* cockpit = [[TTGSprite alloc] initWithFile:@"cockpit.png"];
        cockpit.scale = CGSizeMake(1.5, 1);
        [cockpit moveToX:width/2.0 Y:height/2.0];
        [testScene2 attachNode:cockpit];
        [testScene2 attachNode:[[ReturnSprite alloc] init]];
    }
    return self;
}

@end
