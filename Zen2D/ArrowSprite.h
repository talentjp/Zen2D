//
//  ArrowSprite.h
//  Zen2D
//
//  Created by Roger Cheng on 10/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZSprite.h"
#import "ZTouchComponent.h"

@class ZTouchComponent;

@interface ArrowSprite : ZSprite
{
    ZTouchComponent* _touchComp;
}

@end
