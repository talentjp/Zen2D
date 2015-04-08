//
//  DemoBasicScene.m
//  Zen2D
//
//  Created by Roger Cheng on 10/13/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoBasicScene.h"
#import "TTGDeviceManager.h"
#import "TTGSprite.h"
#import "ReturnSprite.h"
#import "TTGBatch.h"
#import "TTGRotate.h"
#import "TTGTrigger.h"
#import "TTGMoveTo.h"

@implementation DemoBasicScene

- (id)init
{
    float width = [[TTGDeviceManager sharedManager] getScreenWidth];
    float height = [[TTGDeviceManager sharedManager] getScreenHeight];;
    
    if((self = [super initWithWidth:width Height:height]))
    {
        TTGNode* globalNode = [[TTGSprite alloc] init];
        
        TTGSprite* girlTorso = [[TTGSprite alloc] initWithFile:@"GirlTorso.png"];
        girlTorso.scale = CGSizeMake(0.8, 0.8);
        girlTorso.identifier = @"Girl Torso";
        [girlTorso moveToX: 240.0 / 480.0 * width Y: 210.0 / 320.0 * height];
        
        TTGSprite* girlLeftArm = [[TTGSprite alloc] initWithFile:@"LeftArm.png"];
        girlLeftArm.scale = CGSizeMake(0.8, 0.8);
        girlLeftArm.identifier = @"Girl Left Arm";
        [girlLeftArm moveToX:212 / 480.0 * width Y:170 / 320.0 * height];
        girlLeftArm.spriteDepth = 10;
        TTGBatch* leftArmSequence = [TTGBatch executeAnimators:[TTGRotate rotateBy:-30 During:2], [TTGTrigger triggerAnimator:[TTGRotate rotateBy:30 During:2] After:2], nil];
        [girlLeftArm addAnimator:leftArmSequence];
        
        TTGSprite* girlRightArm = [[TTGSprite alloc] initWithFile:@"RightArm.png"];
        girlRightArm.scale = CGSizeMake(0.8, 0.8);
        girlRightArm.identifier = @"Girl Right Arm";
        [girlRightArm moveToX:269 / 480.0 * width Y:171 / 320.0 * height];
        girlRightArm.spriteDepth = 10;
        TTGBatch* rightArmSequence = [TTGBatch executeAnimators:[TTGRotate rotateBy:30 During:2], [TTGTrigger triggerAnimator:[TTGRotate rotateBy:-30 During:2] After:2], nil];
        [girlRightArm addAnimator:rightArmSequence];
        
        TTGSprite* leftLeg = [[TTGSprite alloc] initWithFile:@"LeftLeg.png"];
        leftLeg.scale = CGSizeMake(0.8, 0.8);
        leftLeg.identifier = @"Girl Left Leg";
        [leftLeg moveToX:233 / 480.0 * width Y:133 / 320.0 * height];
        leftLeg.spriteDepth = 10;
        TTGBatch* leftLegSequence = [TTGBatch executeAnimators:[TTGRotate rotateBy:-20 During:2], [TTGTrigger triggerAnimator:[TTGRotate rotateBy:20 During:2] After:2], nil];
        [leftLeg addAnimator:leftLegSequence];
        
        TTGSprite* rightLeg = [[TTGSprite alloc] initWithFile:@"RightLeg.png"];
        rightLeg.scale = CGSizeMake(0.8, 0.8);
        rightLeg.identifier = @"Girl Right Leg";
        [rightLeg moveToX:254 / 480.0 * width Y:133 / 320.0 * height];
        rightLeg.spriteDepth = 10;
        TTGBatch* rightLegSequence = [TTGBatch executeAnimators:[TTGRotate rotateBy:20 During:2], [TTGTrigger triggerAnimator:[TTGRotate rotateBy:-20 During:2] After:2], nil];
        [rightLeg addAnimator:rightLegSequence];
        
        [globalNode attachNode:girlTorso];
        [globalNode attachNode:girlRightArm];
        [globalNode attachNode:girlLeftArm];
        [globalNode attachNode:rightLeg];
        [globalNode attachNode:leftLeg];
        [self attachNode:globalNode];
        
        globalNode.spritePosition = CGPointMake(-100, 0);
        [globalNode addAnimator:[TTGMoveTo moveToX:0 Y:0 During:4]];
        
        [self attachNode:[[ReturnSprite alloc] init]];
    }
    return self;
}

- (void)updateWithTime:(float)deltaTime
{
    [super updateWithTime:deltaTime];
}

@end
