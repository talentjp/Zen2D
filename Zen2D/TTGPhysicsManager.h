//
//  TTGPhysicsManager.h
//  Zen2D
//
//  Created by Roger Cheng on 7/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
class b2World;
@class TTGRigidbodyComponent;

@interface TTGPhysicsManager : NSObject
{
    NSTimer* _timer;
    b2World* _theWorld;
    int _velocityIterations;
    int _positionIterations;
    float _timeStep;
}
@property (assign) float meterPixelRatio;
@property (strong) NSMutableArray* arrayRigidbodyComponents;

+ (TTGPhysicsManager*) sharedManager;
- (void) step;
- (void) addRigidbodyComponent:(TTGRigidbodyComponent*)component;
- (void) removeComponent:(TTGRigidbodyComponent*)component;
- (b2World*) getWorld;
- (float) getMeterPixelRatio;

@end
