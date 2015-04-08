//
//  DemoSpriteAnimation.m
//  Zen2D
//
//  Created by Roger Cheng on 10/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoSpriteAnimation.h"
#import "TTGSpriteAnimation.h"
#import "TTGDeviceManager.h"
#import "TTGSceneManager.h"
#import "ReturnSprite.h"

@implementation DemoSpriteAnimation

- (id)init
{
    float width = [[TTGDeviceManager sharedManager] getScreenWidth];
    float height = [[TTGDeviceManager sharedManager] getScreenHeight];;
    if((self = [super initWithWidth:width Height:height]))
    {
        [[TTGTextureManager sharedManager] loadJSONSpriteSheet:@"megaman3d.json"];
        TTGSpriteAnimation* megaman = [[TTGSpriteAnimation alloc] init];
        
        NSMutableArray* arrayMegaman = [NSMutableArray array];
        for(int i = 0; i <= 47;i++)
        {
            [arrayMegaman addObject:[NSString stringWithFormat:@"Megaman%02d.gif",i]];
        }
        [megaman loadSpritesFromArrayOfFiles:arrayMegaman];
        [megaman defineAnimationNamed:@"megaman_FULL" OfDuration:1.5 AsSpriteIndices:0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,
         18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,nil];
        [megaman playAnimation:@"megaman_FULL" Looped:YES];
        megaman.spritePosition = CGPointMake(250,150);
        megaman.scale = CGSizeMake(1, 1);
        megaman.spriteDepth = -100;
        NSLog(@"Sprite depth = %f", megaman.spriteDepth);
        [self attachNode:megaman];
        [self attachNode:[[ReturnSprite alloc] init]];
    }
    return self;
}

@end