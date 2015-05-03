//
//  ZRigidbodyComponent.m
//  Zen2D
//
//  Created by Roger Cheng on 7/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZRigidbodyComponent.h"
#import "ZPhysicsManager.h"
#import "ZNode.h"
#import "ZSprite.h"

@implementation ZRigidbodyComponent

@synthesize bodyDensity = _bodyDensity;
@synthesize bodyFriction = _bodyFriction;
@synthesize parentNode = _parentNode;

- (id)init
{
    if((self = [super init]))
    {
        _body = nil;
        _bodyDensity = 1.0f;
        _bodyFriction = 0.03f;
        _bodyType = b2_dynamicBody;
        _selectedShape = SHAPE_NO_ENUM;
        _isFixtureDefined = NO;
    }
    return self;
}

- (void)cleanup
{
    if(_body)
    {
        [[ZPhysicsManager sharedManager] getWorld]->DestroyBody(_body);
        _body = nil;
    }
    [[ZPhysicsManager sharedManager] removeComponent:self];
}

- (void)setupAsBoxWithInferredDimensions
{
    if(_parentNode)
    {
        [self computeFixtureDefForBox];
        [self recomputeBody];
        
    }
    else
    {
        //Deferred computation of fixture
        _selectedShape = SHAPE_BOX_ENUM;
    }
}

- (void)setupAsCircleWithInferredRadius
{
    if(_parentNode)
    {
        [self computeFixtureDefForCircle];
        [self recomputeBody];
    }
    else
    {
        //Deferred computation of fixture
        _selectedShape = SHAPE_CIRCLE_ENUM;
    }
}

- (void)computeFixtureDefForJSON
{
    NSString* path = [[NSBundle mainBundle] pathForResource:[_JSONFilename stringByReplacingOccurrencesOfString:@".plist" withString:@""] ofType:@"plist"];
    NSArray* arrayPath = [NSArray arrayWithContentsOfFile:path];
    float scaleH = 1.0;
    float scaleV = 1.0;
    if(_parentNode)
    {
        scaleH = _parentNode.scale.width;
        scaleV = _parentNode.scale.height;
    }
    int vertex_count = (int)[arrayPath count];
    b2Vec2* vertices = new b2Vec2[vertex_count];
    for(int i = 0; i < vertex_count; i++)
    {
        float x = [[[arrayPath objectAtIndex:i] objectForKey:@"X"] floatValue];
        x = x * scaleH/ [[ZPhysicsManager sharedManager] getMeterPixelRatio];
        float y = [[[arrayPath objectAtIndex:i] objectForKey:@"Y"] floatValue];
        y = y * scaleV/ [[ZPhysicsManager sharedManager] getMeterPixelRatio];
        vertices[i].Set(x, y);
    }
    _polygonShape.Set(vertices, vertex_count);
    delete[] vertices;
    _fixtureDef.shape = &_polygonShape;
    _isFixtureDefined = YES;
}

- (void)loadFixtureDataFromFile:(NSString *)filename
{
    _JSONFilename = filename;
    if(_parentNode)
    {
        [self computeFixtureDefForJSON];
        [self recomputeBody];
    }
    else
    {
        //Deferred computation of fixture
        _selectedShape = SHAPE_JSON_ENUM;
    }
}

- (void)setAsDynamicBody
{
    _bodyType = b2_dynamicBody;
    [self recomputeBody];
}

- (void)setAsStaticBody
{
    _bodyType = b2_staticBody;
    [self recomputeBody];
}

- (void)setAsKinematicBody
{
    _bodyType = b2_kinematicBody;
    [self recomputeBody];
}

- (void)computeFixtureDefForBox
{
    if(![_parentNode isKindOfClass:[ZSprite class]])
    {
        NSException* exception = [NSException exceptionWithName:@"PhysicsSetupException"
                                                         reason:@"Cannot infer the dimensions from a non-ZSprite object"
                                                       userInfo:nil];
        @throw exception;
    }
    else
    {
        float width = ((ZSprite*)_parentNode).spriteSize.width * ((ZSprite*)_parentNode).scale.width / [ZPhysicsManager sharedManager].meterPixelRatio / 2.0;
        float height = ((ZSprite*)_parentNode).spriteSize.height * ((ZSprite*)_parentNode).scale.height / [ZPhysicsManager sharedManager].meterPixelRatio  / 2.0;
        _polygonShape.SetAsBox(width, height);
        _fixtureDef.shape = &_polygonShape;
        _isFixtureDefined = YES;
    }
}

- (void)computeFixtureDefForCircle
{
    if(![_parentNode isKindOfClass:[ZSprite class]])
    {
        NSException* exception = [NSException exceptionWithName:@"PhysicsSetupException"
                                                         reason:@"Cannot infer the radius from a non-ZSprite object"
                                                       userInfo:nil];
        @throw exception;
    }
    else
    {
        float width = ((ZSprite*)_parentNode).spriteSize.width * ((ZSprite*)_parentNode).scale.width / [ZPhysicsManager sharedManager].meterPixelRatio / 2.0;
        float height = ((ZSprite*)_parentNode).spriteSize.height * ((ZSprite*)_parentNode).scale.height / [ZPhysicsManager sharedManager].meterPixelRatio / 2.0;
        _circleShape.m_radius = width > height ? width : height;
        _fixtureDef.shape = &_circleShape;
        _isFixtureDefined = YES;
    }
}

- (void)attachedToNode
{
    if(_selectedShape == SHAPE_BOX_ENUM)
    {
        [self computeFixtureDefForBox];
    }
    else if(_selectedShape == SHAPE_CIRCLE_ENUM)
    {
        [self computeFixtureDefForCircle];
    }
    else if(_selectedShape == SHAPE_JSON_ENUM)
    {
        [self computeFixtureDefForJSON];
    }
    //Reset the shape selection once it's computed
    _selectedShape = SHAPE_NO_ENUM;
    //Should set up the position from the node here
    [[ZPhysicsManager sharedManager] addRigidbodyComponent:self];
    if(_isFixtureDefined)
    {
        [self recomputeBody];
    }
}

- (void)recomputeBody
{
    if(_body)
    {
        [[ZPhysicsManager sharedManager] getWorld]->DestroyBody(_body);
    }
    float startX = self.parentNode.spritePosition.x / [[ZPhysicsManager sharedManager] getMeterPixelRatio];
    float startY = self.parentNode.spritePosition.y / [[ZPhysicsManager sharedManager] getMeterPixelRatio];
    _bodyDef.type = _bodyType;
    _bodyDef.position.Set(startX, startY);
    _bodyDef.angle = self.parentNode.rotation / 180.0 * 3.1415926;
    _body = [[ZPhysicsManager sharedManager] getWorld]->CreateBody(&_bodyDef);
    _fixtureDef.density = _bodyDensity;
    _fixtureDef.friction = _bodyFriction;
    _body->CreateFixture(&_fixtureDef);
    _body->SetActive(self.isActive);
}

- (void)reset
{
    //Have to remove the existing body because it' moved
    [self recomputeBody];
}

- (void)activate
{
    [super activate];
    if(_body)
    {
        _body->SetActive(YES);
    }
}

- (void)deactivate
{
    [super deactivate];
    if(_body)
    {
        _body->SetActive(NO);
    }
}

- (void)update
{
    if(_body)
    {
        b2Vec2 position = _body->GetPosition();
        float32 angle = _body->GetAngle();
        float meterPixelRatio = [[ZPhysicsManager sharedManager] getMeterPixelRatio];
        [self.parentNode moveToX:position.x * meterPixelRatio  Y:position.y * meterPixelRatio];
        ((ZNode*)self.parentNode).rotation = angle * 180.0 / 3.1415926;
    }
}


- (id)copyWithZone:(NSZone *)zone
{
    ZRigidbodyComponent* newComp = [super copyWithZone:zone];
    if(newComp)
    {
        [newComp copyFixtureDef:_fixtureDef
                      PolyShape:_polygonShape
                    CircleShape:_circleShape
                        BodyDef:_bodyDef
                       BodyType:_bodyType];
    }
    return newComp;
}

- (void)copyFixtureDef:(b2FixtureDef)fixtureDef PolyShape:(b2PolygonShape)polygonShape
           CircleShape:(b2CircleShape)circleShape BodyDef:(b2BodyDef)bodyDef BodyType:(b2BodyType)bodyType
{
    _fixtureDef = fixtureDef;
    _polygonShape = polygonShape;
    _circleShape = circleShape;
    _bodyDef = bodyDef;
    _bodyType = bodyType;
}


@end
