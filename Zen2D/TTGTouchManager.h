//
//  TTGTouchManager.h
//  Zen2D
//
//  Created by Roger Cheng on 4/28/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TTGScene;

@protocol TouchDelegate <NSObject>

@required
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface TTGTouchManager : NSObject <TouchDelegate>
{
    BOOL _touchCancelled;
    BOOL _isSortingRequired;
}

@property (strong) NSMutableArray* arrayTouchComponents;
@property (strong) NSArray* arraySortedComponents;
+ (TTGTouchManager*) sharedManager;
- (void) addTouchComponent:(id) component;
- (void) removeComponent:(id) component;
- (CGPoint) getTouchLocation:(UITouch*) touch inScene:(TTGScene*)scene;
- (void) cancelTouch;
- (void) recalculateSortedComponents;

@end
