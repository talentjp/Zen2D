//
//  ZPhysicsManager.m
//  Zen2D
//
//  Created by Roger Cheng on 7/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZPhysicsManager.h"
#import <Box2D/Box2D.h>
#import "ZSceneManager.h"
#import "ZScene.h"

static ZPhysicsManager* singleton = nil;

@implementation ZPhysicsManager
@synthesize meterPixelRatio = _meterPixelRatio;
@synthesize arrayRigidbodyComponents = _arrayRigidbodyComponents;

+ (ZPhysicsManager *)sharedManager
{
    @synchronized(singleton)
    {
        if(!singleton)
        {
            singleton = [[ZPhysicsManager alloc] init];
        }
    }
    return singleton;
}


- (id)init
{
    if((self = [super init]))
    {
        singleton = self;
        _arrayRigidbodyComponents = [NSMutableArray array];
        b2Vec2 gravity(0, -10);
        _theWorld = new b2World(gravity);
        //Default meter : pixel = 1:20
        _meterPixelRatio = 20;
        //Number of iterations for a step
        _velocityIterations = 6;
        _positionIterations = 2;
        //groundBodyDef.angle = 45.0 * 3.1415926 / 180.0;
        //Box2D engine recommends 1/60 sec for each step
        _timeStep = 1.0 / 60.0;
        
        
        // Define the ground body.
        b2BodyDef groundBodyDef;
        
        
        float screenWidth = [ZSceneManager sharedManager].mainScene.screenWidth;
        float screenHeight = [ZSceneManager sharedManager].mainScene.screenHeight;
        
        groundBodyDef.position.Set(screenWidth / 2.0 / _meterPixelRatio, -0.5f);
        // Call the body factory which allocates memory for the ground body
        // from a pool and creates the ground box shape (also from a pool).
        // The body is also added to the world.
        b2Body* groundBody = _theWorld->CreateBody(&groundBodyDef);
        // Define the ground box shape.
        b2PolygonShape groundBox;
        // The extents are the half-widths of the box.
        groundBox.SetAsBox(200.0f, 0.5f);
        // Add the ground fixture to the ground body.
        groundBody->CreateFixture(&groundBox, 0.0f);
        
        
        b2BodyDef leftWallBodyDef;
        leftWallBodyDef.position.Set(-0.5, screenHeight / 2.0 / _meterPixelRatio);
        b2Body* leftWallBody = _theWorld->CreateBody(&leftWallBodyDef);
        b2PolygonShape leftWallBox;
        leftWallBox.SetAsBox(0.5f, 200.0f);
        leftWallBody->CreateFixture(&leftWallBox, 0.0f);
        
        
        b2BodyDef rightWallBodyDef;
        rightWallBodyDef.position.Set(screenWidth / _meterPixelRatio + 0.5, screenHeight / 2.0 / _meterPixelRatio);
        b2Body* rightWallBody = _theWorld->CreateBody(&rightWallBodyDef);
        b2PolygonShape rightWallBox;
        rightWallBox.SetAsBox(0.5f, 200.0f);
        rightWallBody->CreateFixture(&rightWallBox, 0.0f);
        
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(step) userInfo:nil repeats:YES];
    }
    return singleton;
}

- (void)step
{
    _theWorld->Step(_timeStep, _velocityIterations, _positionIterations);
}

- (b2World *)getWorld
{
    return _theWorld;
}

- (float)getMeterPixelRatio
{
    return _meterPixelRatio;
}

- (void)addRigidbodyComponent:(ZRigidbodyComponent *)component
{
    [_arrayRigidbodyComponents addObject:component];
}

- (void)removeComponent:(ZRigidbodyComponent *)component
{
    [_arrayRigidbodyComponents removeObject:component];
}

- (void)dealloc
{
    if(_timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    if(_theWorld)
    {
        delete _theWorld;
        _theWorld = nil;
    }
}

@end
