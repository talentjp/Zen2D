//
//  TTGRigidbodyComponent.h
//  Zen2D
//
//  Created by Roger Cheng on 7/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTGComponent.h"
#import <Box2D/Box2D.h>


typedef enum{
    SHAPE_NO_ENUM = 0,
    SHAPE_BOX_ENUM = 1,
    SHAPE_CIRCLE_ENUM = 2,
    SHAPE_JSON_ENUM = 3
}PhysicsShapeName;

@class TTGNode;
class b2Body;

@interface TTGRigidbodyComponent : TTGComponent
{
    b2Body* _body;
    b2FixtureDef _fixtureDef;
    b2PolygonShape _polygonShape;
    b2CircleShape _circleShape;
    b2BodyDef _bodyDef;
    b2BodyType _bodyType;
    PhysicsShapeName _selectedShape;
    BOOL _isFixtureDefined;
    NSString* _JSONFilename;
}

@property (weak) TTGNode* parentNode;

@property (assign) float bodyDensity;
@property (assign) float bodyFriction;

- (void)setupAsBoxWithInferredDimensions;
- (void)setupAsCircleWithInferredRadius;
- (void)loadFixtureDataFromFile:(NSString*)filename;
- (void)setAsDynamicBody;
- (void)setAsStaticBody;
- (void)setAsKinematicBody;
- (void)copyFixtureDef:(b2FixtureDef)fixtureDef PolyShape:(b2PolygonShape)polygonShape
           CircleShape:(b2CircleShape)circleShape BodyDef:(b2BodyDef)bodyDef BodyType:(b2BodyType)bodyType;
- (void)computeFixtureDefForBox;
- (void)computeFixtureDefForCircle;
- (void)computeFixtureDefForJSON;
- (void)recomputeBody;

@end
