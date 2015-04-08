//
//  TTGMovingText.m
//  Zen2D
//
//  Created by Roger Cheng on 5/9/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TouchableText.h"
#import "TTGTouchComponent.h"
#import "TTGScene.h"
#import "TTGVirtualStick.h"
#import "TTGMoveTo.h"
#import "SceneSelectScene.h"

@implementation TouchableText

- (id)initWithString:(NSString *)text
{
    if((self = [super initWithString:text]))
    {
        _touchComp = [[TTGTouchComponent alloc] init];
        [self addComponent: _touchComp];
    }
    return self;
}

- (void)gameUpdate
{
    if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_DOWN)
    {
        self.scale = CGSizeMake(2.0, 2.0);
    }
    else if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_MOVE)
    {
        if([self isLocationWithinSprite:[_touchComp getLatestLocationAtIndex:0]])
        {
            self.scale = CGSizeMake(2.0, 2.0);
        }
        else
        {
            self.scale = CGSizeMake(1.5, 1.5);
        }
    }
    else if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_UP)
    {
        if([self isLocationWithinSprite:[_touchComp getLatestLocationAtIndex:0]])
        {
            self.scale = CGSizeMake(1.5, 1.5);
            [(SceneSelectScene*)self.parentScene enterScene];
        }
        else
        {
            self.scale = CGSizeMake(1.5, 1.5);
        }
    }
}

@end
