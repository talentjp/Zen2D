//
//  ZDeviceManager.m
//  Zen2D
//
//  Created by Roger Cheng on 10/13/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZDeviceManager.h"

static ZDeviceManager* singleton = nil;

@implementation ZDeviceManager

+ (ZDeviceManager *)sharedManager
{
    @synchronized(singleton)
    {
        if(!singleton)
        {
            singleton = [[ZDeviceManager alloc] init];
        }
    }
    return singleton;
}

- (id)init
{
    if((self = [super init]))
    {
        singleton = self;
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return singleton;
}

- (float)getScreenWidth
{
    return _screenWidth;
}

- (float)getScreenHeight
{
    return _screenHeight;
}


@end
