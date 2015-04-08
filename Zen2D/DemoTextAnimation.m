//
//  DemoTextAnimation.m
//  Zen2D
//
//  Created by Roger Cheng on 10/13/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoTextAnimation.h"
#import "TTGText.h"
#import "TTGBatch.h"
#import "TTGFade.h"
#import "TTGRotate.h"
#import "TTGScale.h"
#import "TTGShake.h"
#import "TTGTrigger.h"
#import "TTGDeviceManager.h"
#import "ReturnSprite.h"

@implementation DemoTextAnimation

- (id)init
{
    float width = [[TTGDeviceManager sharedManager] getScreenWidth];;
    float height = [[TTGDeviceManager sharedManager] getScreenHeight];;
    
    if((self = [super initWithWidth:width Height:height]))
    {
        //Animator test
        TTGText* text = [[TTGText alloc] initWithString:@"TEST"];
        text.spritePosition = CGPointMake(width / 2.0, height / 2.0);
        text.scale = CGSizeMake(2.0, 2.0);
        [text setTextColor:[UIColor yellowColor]];
        [self attachNode:text];
        text.spriteDepth = -100;
        text.opacity = 1.0;
        text.identifier = @"TEXT";
        text.opacity = 0.1;
        TTGBatch* newSequencer = [TTGBatch executeAnimators:[TTGFade fadeInDuring:2.0], [TTGRotate rotateBy:720 During:2.0], [TTGScale scaleToWidth:4.0 Height:4.0 During:2.0], [TTGShake shakeWithinDistance:50 During:2], nil];
        TTGTrigger* newTrigger = [TTGTrigger triggerAnimator:newSequencer After:2.0];
        [text addAnimator:newTrigger];
        TTGTrigger* newTrigger2 = [TTGTrigger triggerAnimator:[TTGBatch executeAnimators:[TTGFade fadeOutDuring:2.0],[TTGScale scaleToWidth:8.0 Height:2.0 During:2.0],nil] After:4.0];
        [text addAnimator:newTrigger2];
        [self attachNode:[[ReturnSprite alloc] init]];
    }
    return self;
}

@end
