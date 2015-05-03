//
//  ArrowSprite.m
//  Zen2D
//
//  Created by Roger Cheng on 10/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ArrowSprite.h"
#import "ZTouchComponent.h"
#import "SceneSelectScene.h"

@implementation ArrowSprite

- (id)init
{
    if((self = [super initWithFile:@"RightArrow.png"]))
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
    else if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_MOVE)
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
            if([self.identifier isEqualToString:@"RightArrow"])
                [(SceneSelectScene*)self.parentScene nextScene];
            else if([self.identifier isEqualToString:@"LeftArrow"])
                [(SceneSelectScene*)self.parentScene prevScene];
        }
        else
        {
            self.scale = CGSizeMake(0.2, 0.2);
        }
    }
}

@end
