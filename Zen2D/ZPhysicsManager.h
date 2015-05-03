//
//  ZPhysicsManager.h
//  Zen2D
//
//  Created by Roger Cheng on 7/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
class b2World;
@class ZRigidbodyComponent;

@interface ZPhysicsManager : NSObject
{
    NSTimer* _timer;
    b2World* _theWorld;
    int _velocityIterations;
    int _positionIterations;
    float _timeStep;
}
@property (assign) float meterPixelRatio;
@property (strong) NSMutableArray* arrayRigidbodyComponents;

+ (ZPhysicsManager*) sharedManager;
- (void) step;
- (void) addRigidbodyComponent:(ZRigidbodyComponent*)component;
- (void) removeComponent:(ZRigidbodyComponent*)component;
- (b2World*) getWorld;
- (float) getMeterPixelRatio;

@end
