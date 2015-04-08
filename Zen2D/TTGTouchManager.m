//
//  TTGTouchManager.m
//  Zen2D
//
//  Created by Roger Cheng on 4/28/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGTouchManager.h"
#import "TTGTouchComponent.h"
#import "TTGSprite.h"
#import "TTGScene.h"
#import "TTGSceneManager.h"

static TTGTouchManager* singleton = nil;

@implementation TTGTouchManager

@synthesize arrayTouchComponents;
@synthesize arraySortedComponents;

+ (TTGTouchManager *)sharedManager
{
    @synchronized(singleton)
    {
        if(!singleton)
        {
            singleton = [[TTGTouchManager alloc] init];
        }
    }
    return singleton;
}

- (id)init
{
    if((self = [super init]))
    {
        singleton = self;
        self.arrayTouchComponents = [NSMutableArray array];
        self.arraySortedComponents = [NSArray array];
        _touchCancelled = NO;
        _isSortingRequired = NO;
    }
    
    return singleton;
}


- (void)addTouchComponent:(id)component
{
    [self.arrayTouchComponents addObject:component];
    _isSortingRequired = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        for(TTGTouchComponent* component in self.arraySortedComponents)
        {
            //Only process the touch if the parent scene is active
            if(component.isActive)
            {
                [component touchBegan:touch withEvent:event];
            }
            if(_touchCancelled) //Only the touch began can be cancelled
            {
                break;
            }
        }
        _touchCancelled = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        for(TTGTouchComponent* component in self.arraySortedComponents)
        {
            if(component.isActive)
            {
                [component touchMoved:touch withEvent:event];
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch* touch in touches)
    {
        for(TTGTouchComponent* component in self.arraySortedComponents)
        {
            if(component.isActive)
            {
                [component touchEnded:touch withEvent:event];
            }
        }
    }
}

- (void)cancelTouch
{
    _touchCancelled = YES;
}

- (void)recalculateSortedComponents
{
    //Only re-sort when it's required (dirty)
    if(_isSortingRequired)
    {        
        //Need to optimize the sorting function (bucket sort?)
        self.arraySortedComponents = [self.arrayTouchComponents sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            TTGTouchComponent* comp1 = obj1;
            TTGTouchComponent* comp2 = obj2;
            if([comp1 getParentDepth] > [comp2 getParentDepth])
            {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if([comp1 getParentDepth] < [comp2 getParentDepth])
            {
                return (NSComparisonResult)NSOrderedAscending;
            }
            
            return (NSComparisonResult)NSOrderedSame;
        }];
        _isSortingRequired = NO;
    }
}

- (void)removeComponent:(id)component
{
    [self.arrayTouchComponents removeObject:component];
    _isSortingRequired = YES;
}

- (CGPoint)getTouchLocation:(UITouch *)touch inScene:(TTGScene *)scene
{
    if(scene)
    {
        CGPoint location = [touch locationInView:touch.view];
        return CGPointMake(location.x, scene.screenHeight - 1 - location.y);
    }
    //Return (0,0) as a fake location if there is no active scene
    return CGPointMake(0,0);
}

@end
