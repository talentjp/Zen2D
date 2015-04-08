//
//  DemoTetris.m
//  Zen2D
//
//  Created by Roger Cheng on 10/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoTetris.h"
#import "TTGDeviceManager.h"
#import "TTGSprite.h"
#import "MyJoystick.h"
#import "ReturnSprite.h"

@implementation DemoTetris
- (id)init
{
    float width = [[TTGDeviceManager sharedManager] getScreenWidth];
    float height = [[TTGDeviceManager sharedManager] getScreenHeight];;
    
    if((self = [super initWithWidth:width Height:height]))
    {
        TTGSprite* bgImage = [[TTGSprite alloc] initWithFile:@"TetrisBackground.png"];
        [self attachNode:bgImage];
        bgImage.spriteDepth = 100;
        bgImage.spritePosition = CGPointMake(240, 160);
        bgImage.opacity = 1.0;
        MyJoystick* stick = [[MyJoystick alloc] init];
        [self attachNode:stick];
        //Need to adjust the position of the return icon as this is the right button
        ReturnSprite* returnIcon = [[ReturnSprite alloc] init];
        [self attachNode:returnIcon];
        [returnIcon moveToX:width - 50 Y:height - 50];
        
    }
    return self;
}

@end
