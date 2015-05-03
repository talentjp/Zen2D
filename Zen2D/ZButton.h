//
//  ZButton.h
//  Zen2D
//
//  Created by Roger Cheng on 7/13/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZSprite.h"
@class ZTouchComponent;

@interface TTGFuncSelector : NSObject
@property (assign) SEL selector;
@end

@interface ZButton : ZSprite
{
    ZTouchComponent* _touchComp;
    NSMapTable* _weakMapSubscribingObjects;
}

//It's the subscriber's responsibility to remove itself once done
- (void) subscribeWithObject:(id)object AndSelector:(SEL)selector;
- (void) removeSubscriber:(id)object;
- (void) removeSelector:(SEL)selector ForObject:(id)object;
- (void) buttonPressed;

@end
