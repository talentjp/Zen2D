//
//  ArrowSprite.h
//  Zen2D
//
//  Created by Roger Cheng on 10/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGSprite.h"
#import "TTGTouchComponent.h"

@class TTGTouchComponent;

@interface ArrowSprite : TTGSprite
{
    TTGTouchComponent* _touchComp;
}

@end
