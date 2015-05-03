//
//  DemoTextAnimation.m
//  Zen2D
//
//  Created by Roger Cheng on 10/13/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoTextAnimation.h"
#import "ZText.h"
#import "ZBatch.h"
#import "ZFade.h"
#import "ZRotate.h"
#import "ZScale.h"
#import "ZShake.h"
#import "ZTrigger.h"
#import "ZDeviceManager.h"
#import "ReturnSprite.h"

@implementation DemoTextAnimation

- (id)init
{
    float width = [[ZDeviceManager sharedManager] getScreenWidth];;
    float height = [[ZDeviceManager sharedManager] getScreenHeight];;
    
    if((self = [super initWithWidth:width Height:height]))
    {
        //Animator test
        ZText* text = [[ZText alloc] initWithString:@"TEST"];
        text.spritePosition = CGPointMake(width / 2.0, height / 2.0);
        text.scale = CGSizeMake(2.0, 2.0);
        [text setTextColor:[UIColor yellowColor]];
        [self attachNode:text];
        text.spriteDepth = -100;
        text.opacity = 1.0;
        text.identifier = @"TEXT";
        text.opacity = 0.1;
        ZBatch* newSequencer = [ZBatch executeAnimators:[ZFade fadeInDuring:2.0], [ZRotate rotateBy:720 During:2.0], [ZScale scaleToWidth:4.0 Height:4.0 During:2.0], [ZShake shakeWithinDistance:50 During:2], nil];
        ZTrigger* newTrigger = [ZTrigger triggerAnimator:newSequencer After:2.0];
        [text addAnimator:newTrigger];
        ZTrigger* newTrigger2 = [ZTrigger triggerAnimator:[ZBatch executeAnimators:[ZFade fadeOutDuring:2.0],[ZScale scaleToWidth:8.0 Height:2.0 During:2.0],nil] After:4.0];
        [text addAnimator:newTrigger2];
        [self attachNode:[[ReturnSprite alloc] init]];
    }
    return self;
}

@end
