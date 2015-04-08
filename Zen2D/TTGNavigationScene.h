//
//  TTGNavigationScene.h
//  Zen2D
//
//  Created by Roger Cheng on 7/26/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "TTGScene.h"
#include <vector>

@interface TTGNavigationScene : TTGScene
{
    std::vector<CFTypeRef> _stackScenes;
    BOOL _isActive;
}

- (void)pushScene:(TTGScene*)newScene;
- (TTGScene*)popScene;

@end
