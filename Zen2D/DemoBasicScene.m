//
//  DemoBasicScene.m
//  Zen2D
//
//  Created by Roger Cheng on 10/13/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoBasicScene.h"
#import "ZDeviceManager.h"
#import "ZSprite.h"
#import "ReturnSprite.h"
#import "ZBatch.h"
#import "ZRotate.h"
#import "ZTrigger.h"
#import "ZMoveTo.h"

@implementation DemoBasicScene

- (id)init
{
    float width = [[ZDeviceManager sharedManager] getScreenWidth];
    float height = [[ZDeviceManager sharedManager] getScreenHeight];;
    
    if((self = [super initWithWidth:width Height:height]))
    {
        ZNode* globalNode = [[ZSprite alloc] init];
        
        ZSprite* girlTorso = [[ZSprite alloc] initWithFile:@"GirlTorso.png"];
        girlTorso.scale = CGSizeMake(0.8, 0.8);
        girlTorso.identifier = @"Girl Torso";
        [girlTorso moveToX: 240.0 / 480.0 * width Y: 210.0 / 320.0 * height];
        
        ZSprite* girlLeftArm = [[ZSprite alloc] initWithFile:@"LeftArm.png"];
        girlLeftArm.scale = CGSizeMake(0.8, 0.8);
        girlLeftArm.identifier = @"Girl Left Arm";
        [girlLeftArm moveToX:212 / 480.0 * width Y:170 / 320.0 * height];
        girlLeftArm.spriteDepth = 10;
        ZBatch* leftArmSequence = [ZBatch executeAnimators:[ZRotate rotateBy:-30 During:2], [ZTrigger triggerAnimator:[ZRotate rotateBy:30 During:2] After:2], nil];
        [girlLeftArm addAnimator:leftArmSequence];
        
        ZSprite* girlRightArm = [[ZSprite alloc] initWithFile:@"RightArm.png"];
        girlRightArm.scale = CGSizeMake(0.8, 0.8);
        girlRightArm.identifier = @"Girl Right Arm";
        [girlRightArm moveToX:269 / 480.0 * width Y:171 / 320.0 * height];
        girlRightArm.spriteDepth = 10;
        ZBatch* rightArmSequence = [ZBatch executeAnimators:[ZRotate rotateBy:30 During:2], [ZTrigger triggerAnimator:[ZRotate rotateBy:-30 During:2] After:2], nil];
        [girlRightArm addAnimator:rightArmSequence];
        
        ZSprite* leftLeg = [[ZSprite alloc] initWithFile:@"LeftLeg.png"];
        leftLeg.scale = CGSizeMake(0.8, 0.8);
        leftLeg.identifier = @"Girl Left Leg";
        [leftLeg moveToX:233 / 480.0 * width Y:133 / 320.0 * height];
        leftLeg.spriteDepth = 10;
        ZBatch* leftLegSequence = [ZBatch executeAnimators:[ZRotate rotateBy:-20 During:2], [ZTrigger triggerAnimator:[ZRotate rotateBy:20 During:2] After:2], nil];
        [leftLeg addAnimator:leftLegSequence];
        
        ZSprite* rightLeg = [[ZSprite alloc] initWithFile:@"RightLeg.png"];
        rightLeg.scale = CGSizeMake(0.8, 0.8);
        rightLeg.identifier = @"Girl Right Leg";
        [rightLeg moveToX:254 / 480.0 * width Y:133 / 320.0 * height];
        rightLeg.spriteDepth = 10;
        ZBatch* rightLegSequence = [ZBatch executeAnimators:[ZRotate rotateBy:20 During:2], [ZTrigger triggerAnimator:[ZRotate rotateBy:-20 During:2] After:2], nil];
        [rightLeg addAnimator:rightLegSequence];
        
        [globalNode attachNode:girlTorso];
        [globalNode attachNode:girlRightArm];
        [globalNode attachNode:girlLeftArm];
        [globalNode attachNode:rightLeg];
        [globalNode attachNode:leftLeg];
        [self attachNode:globalNode];
        
        globalNode.spritePosition = CGPointMake(-100, 0);
        [globalNode addAnimator:[ZMoveTo moveToX:0 Y:0 During:4]];
        
        [self attachNode:[[ReturnSprite alloc] init]];
    }
    return self;
}

- (void)updateWithTime:(float)deltaTime
{
    [super updateWithTime:deltaTime];
}

@end
