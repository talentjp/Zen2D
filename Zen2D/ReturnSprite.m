//
//  ReturnSprite.m
//  Zen2D
//
//  Created by Roger Cheng on 10/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ReturnSprite.h"
#import "ZSceneManager.h"
#import "SceneSelectScene.h"

@implementation ReturnSprite

- (id)init
{
    if((self = [super initWithFile:@"Return"]))
    {
        //Component based design
        _touchComp = [[ZTouchComponent alloc] init];
        [self addComponent: _touchComp];
        self.scale = CGSizeMake(0.2, 0.2);
    }
    return self;
}

- (void)gameUpdate
{
    if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_DOWN)
    {
        self.scale = CGSizeMake(0.3, 0.3);
    }
    else if([_touchComp getLatestTouchEventAtIndex:0]== TOUCH_EVENT_MOVE)
    {
        if([self isLocationWithinSprite:[_touchComp getLatestLocationAtIndex:0]])
        {
            self.scale = CGSizeMake(0.3, 0.3);
        }
        else
        {
            self.scale = CGSizeMake(0.2, 0.2);
        }
    }
    else if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_UP)
    {
        if([self isLocationWithinSprite:[_touchComp getLatestLocationAtIndex:0]])
        {
            self.scale = CGSizeMake(0.2, 0.2);
            [[ZSceneManager sharedManager] switchToScene:[[SceneSelectScene alloc] init]];
        }
        else
        {
            self.scale = CGSizeMake(0.2, 0.2);
        }
    }
}

- (void)setParentScene:(ZScene *)parentScene
{
    [super setParentScene:parentScene];
    [self moveToX:self.parentScene.screenWidth - 50 Y:50];
}

@end
