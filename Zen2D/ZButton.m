//
//  ZButton.m
//  Zen2D
//
//  Created by Roger Cheng on 7/13/14.
//  Copyright (c) 2014 Roger Cheng. All rights reserved.
//

#import "ZButton.h"
#import "ZTouchComponent.h"

@implementation TTGFuncSelector
@synthesize selector = _selector;
- (id)initWithSelector:(SEL)selector
{
    if((self = [super init]))
    {
        _selector = selector;
    }
    return self;
}
@end

static const float BRIGHTNESS_ATTENUATION = 0.7;
static const float SHRINK_FACTOR = 0.85;

@implementation ZButton

- (id)initWithFile:(NSString *)fileName
{
    if((self = [super initWithFile:fileName]))
    {
        self.brightness = BRIGHTNESS_ATTENUATION;
        _touchComp = [[ZTouchComponent alloc] init];
        [self addComponent: _touchComp];
        _weakMapSubscribingObjects = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsStrongMemory];
    }
    return self;
}

-(void)gameUpdate
{
    if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_DOWN)
    {
        self.brightness = 1.0;
        self.scale = CGSizeMake(SHRINK_FACTOR, SHRINK_FACTOR);
    }
    else if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_UP || [_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_DOWN_UP)
    {
        self.brightness = BRIGHTNESS_ATTENUATION;
        self.scale = CGSizeMake(1.0, 1.0);
        [self buttonPressed];
    }
}

- (void)subscribeWithObject:(id)object AndSelector:(SEL)selector
{
    TTGFuncSelector* newSubscriber = [[TTGFuncSelector alloc] initWithSelector:selector];
    if([_weakMapSubscribingObjects objectForKey:object])
    {
        [[_weakMapSubscribingObjects objectForKey:object] addObject:newSubscriber];
    }
    else
    {
        [_weakMapSubscribingObjects setObject:[NSMutableArray arrayWithObject:newSubscriber] forKey:object];
    }
}

- (void)removeSubscriber:(id)object
{
    [_weakMapSubscribingObjects removeObjectForKey:object];
}

- (void)removeSelector:(SEL)selector ForObject:(id)object
{
    if([_weakMapSubscribingObjects objectForKey:object])
    {
        NSMutableArray* array = [_weakMapSubscribingObjects objectForKey:object];
        TTGFuncSelector* to_delete = nil;
        for(TTGFuncSelector* embedded_selector in array)
        {
            if(embedded_selector.selector == selector)
            {
                to_delete = embedded_selector;
            }
        }
        [array removeObject:to_delete];
    }
}

- (void)buttonPressed
{
    NSEnumerator *enumerator = [_weakMapSubscribingObjects keyEnumerator];
    for(id obj in enumerator)
    {
        for(TTGFuncSelector* subscriber in [_weakMapSubscribingObjects objectForKey:obj])
        {
            [obj performSelector:subscriber.selector withObject:self afterDelay:0.0f];
        }
    }
}

@end
