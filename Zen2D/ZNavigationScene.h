//
//  ZNavigationScene.h
//  Zen2D
//
//  Created by Roger Cheng on 7/26/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZScene.h"
#include <vector>

@interface ZNavigationScene : ZScene
{
    std::vector<CFTypeRef> _stackScenes;
    BOOL _isActive;
}

- (void)pushScene:(ZScene*)newScene;
- (ZScene*)popScene;

@end
