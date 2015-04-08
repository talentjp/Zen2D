//
//  TTGAnimator.h
//  Zen2D
//
//  Created by Roger Cheng on 6/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTGNode;

@interface TTGAnimator : NSObject

@property (assign) float duration;
@property (assign) float timeElapsed;
@property (assign) float deltaTime;
@property (assign) BOOL isFinished;
@property (weak) TTGNode* nodeToAnimate;

- (void) animateForDeltaTime:(float)deltaTime;
- (void) animateOneFrame;
- (void) animateEndFrame;
- (void) initializeWithNode:(TTGNode*)node;

@end
