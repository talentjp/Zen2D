//
//  DemoPhysicsScene.m
//  Zen2D
//
//  Created by Roger Cheng on 10/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "DemoPhysicsScene.h"
#import "TTGDeviceManager.h"
#import "TTGSprite.h"
#import "TTGSceneManager.h"
#import "TTGRigidbodyComponent.h"
#import "TTGRectangle.h"
#import "PhysicsTouchNode.h"
#import "ReturnSprite.h"

@implementation DemoPhysicsScene

- (id)init
{
    float width = [[TTGDeviceManager sharedManager] getScreenWidth];
    float height = [[TTGDeviceManager sharedManager] getScreenHeight];
    
    if((self = [super initWithWidth:width Height:height]))
    {
        TTGSprite* rock = [[TTGSprite alloc] initWithFile:@"rock.png"];
        rock.identifier = @"ROCK";
        rock.scale = CGSizeMake(1.5, 1.5);
        [self attachNode:rock];
        [rock moveToX:650 Y:600];
        TTGRigidbodyComponent* comp = [[TTGRigidbodyComponent alloc] init];
        [rock addComponent:comp];
        [comp loadFixtureDataFromFile:@"rock.plist"];
        
        TTGRectangle* colorRect = [[TTGRectangle alloc] init];
        colorRect.spriteSize = CGSizeMake(2000, 20);
        colorRect.opacity = 0.5;
        colorRect.solidColor = [UIColor purpleColor];
        [colorRect moveToX:400 Y:50];
        colorRect.rotation = 35;
        comp = [[TTGRigidbodyComponent alloc] init];
        [colorRect addComponent:comp];
        [comp setupAsBoxWithInferredDimensions];
        [comp setAsStaticBody];        
        
        TTGRectangle* colorRect2 = [[TTGRectangle alloc] init];
        colorRect2.spriteSize = CGSizeMake(2000, 20);
        colorRect2.opacity = 0.5;
        colorRect2.solidColor = [UIColor purpleColor];
        [colorRect2 moveToX:480 Y:50];
        colorRect2.rotation = 0;
        
        comp = [[TTGRigidbodyComponent alloc] init];
        [colorRect2 addComponent:comp];
        [comp setupAsBoxWithInferredDimensions];
        [comp setAsStaticBody];
        
        TTGRectangle* colorRect3 = [[TTGRectangle alloc] init];
        colorRect3.spriteSize = CGSizeMake(2000, 20);
        colorRect3.opacity = 0.5;
        colorRect3.solidColor = [UIColor purpleColor];
        [colorRect3 moveToX:100 Y:50];
        colorRect3.rotation = -35;
        
        comp = [[TTGRigidbodyComponent alloc] init];
        [colorRect3 addComponent:comp];
        [comp setupAsBoxWithInferredDimensions];
        [comp setAsStaticBody];
        
        [self attachNode:colorRect];
        [self attachNode:colorRect2];
        [self attachNode:colorRect3];
        [self attachNode:[[PhysicsTouchNode alloc] init]];
        
        [self attachNode:[[ReturnSprite alloc] init]];
    }
    return self;
}


@end
