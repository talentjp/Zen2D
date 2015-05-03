//
//  ZDeviceManager.h
//  Zen2D
//
//  Created by Roger Cheng on 10/13/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDeviceManager : NSObject
{
    //Assume device is in landscape mode
    float _screenWidth;
    float _screenHeight;
}
+ (ZDeviceManager*) sharedManager;
- (float) getScreenWidth;
- (float) getScreenHeight;

@end
