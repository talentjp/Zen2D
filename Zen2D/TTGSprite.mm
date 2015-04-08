//
//  TTGSprite.m
//  Zen2D
//
//  Created by Roger Cheng on 4/20/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//
#import  "TTGSprite.h"
#import  "TTGTouchComponent.h"
#import  "TTGScene.h"
#import  "TTGTextureManager.h"
#import  "TTGTexture.h"

@implementation TTGReferenceCounter
@synthesize count = _count;
-(id)init
{
    if((self = [super init]))
    {
        _count = 0;
    }
    return self;
}

@end


@implementation TTGSprite
@synthesize quad               = _quad;
@synthesize texture            = _texture;
@synthesize spriteSize         = _spriteSize;
@synthesize spriteDepth        = _spriteDepth;
@synthesize isTextureCloned    = _isTextureCloned;
@synthesize cloneCount         = _cloneCount;


- (id)initWithFile:(NSString *)fileName
{
    if((self = [super init]))
    {
        _cloneCount = [[TTGReferenceCounter alloc] init];
        _isTextureCloned = NO;
        _spriteDepth = 0;
        
        [[TTGTextureManager sharedManager] loadImage:fileName];
        _texture = [[TTGTextureManager sharedManager] findTextureByFilename:fileName];
        
        if(!_texture)
        {
            NSLog(@"Cannot find texture named %@ !!!", fileName);
        }
        
        _spriteSize.width = _texture.spriteSize.width;
        _spriteSize.height = _texture.spriteSize.height;
        
        //Note that this IS NOT pixel-correct
        TextureQuad newQuad;
        newQuad.bl.geometryVertex = CGPointMake32(-_spriteSize.width / 2.0, -_spriteSize.height / 2.0);
        newQuad.br.geometryVertex = CGPointMake32(_spriteSize.width / 2.0, -_spriteSize.height / 2.0);
        newQuad.tl.geometryVertex = CGPointMake32(-_spriteSize.width / 2.0, _spriteSize.height / 2.0);
        newQuad.tr.geometryVertex = CGPointMake32(_spriteSize.width / 2.0, _spriteSize.height / 2.0);
        
        float bottom = 1.0 - (float)(_texture.spriteCoordInTexture.y + _spriteSize.height - 1) / (_texture.textureInfo.height - 1);
        float left = (float)_texture.spriteCoordInTexture.x / (_texture.textureInfo.width - 1);
        float top = 1.0 - (float)_texture.spriteCoordInTexture.y / (_texture.textureInfo.height - 1);
        float right = (float)(_texture.spriteCoordInTexture.x + _spriteSize.width - 1) / (_texture.textureInfo.width - 1);
        
        newQuad.bl.textureVertex = CGPointMake32(left, bottom);
        newQuad.br.textureVertex = CGPointMake32(right, bottom);
        newQuad.tl.textureVertex = CGPointMake32(left, top);
        newQuad.tr.textureVertex = CGPointMake32(right, top);
        self.quad = newQuad;
        self.touchMode = TOUCH_MODE_INSIDE;
        
    }
    return self;
}

- (BOOL)isLocationWithinSprite:(CGPoint)location
{
    //Easiest approach, simply inverse transform the touch point with the current model view matrix and compare
    GLKVector4 touchPoint = GLKVector4Make(location.x, location.y, 0, 1);
    GLKVector4 trans_touch = GLKMatrix4MultiplyVector4(GLKMatrix4Invert(_modelViewMat, nil), touchPoint);
    //Reject immediately if it falls outside the sprite
    if(trans_touch.x > _spriteSize.width / 2.0 || trans_touch.x < -_spriteSize.width / 2.0 || trans_touch.y > _spriteSize.height / 2.0 || trans_touch.y < -_spriteSize.height / 2.0)
    {
        return NO;
    }
    //Only if touch falls in the sprite will we process it further
    if([_texture isPixelTransparentAtX:trans_touch.x + _spriteSize.width / 2.0
                                     Y:trans_touch.y + _spriteSize.height / 2.0])
    {
        return NO;
    }
    
    return YES;
}

- (void)render
{
    if(!self.hide)
    {
        self.effect.texture2d0.name = _texture.textureInfo.name;
        self.effect.texture2d0.enabled = YES;
        //self.effect.constantColor = GLKVector4Make(1.0,1.0,1.0,self.opacity);
        self.effect.constantColor = GLKVector4Make(self.brightness,self.brightness,self.brightness,self.opacity);
        self.effect.useConstantColor = YES;
        self.effect.transform.modelviewMatrix = _modelViewMat;
        [self.effect prepareToDraw];
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        
        long offset = (long)&_quad;
        glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TextureVertex), (void*) (offset + offsetof(TextureVertex, geometryVertex)));
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TextureVertex), (void*) (offset + offsetof(TextureVertex, textureVertex)));
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    TTGSprite* newSprite = [super copyWithZone:zone];
    if(newSprite)
    {
        newSprite.quad = _quad;
        //Texture is shared across nodes
        newSprite.texture = _texture;
        newSprite.spriteSize = _spriteSize;
        newSprite.spriteDepth = _spriteDepth;
        newSprite.isTextureCloned = YES;
        newSprite.cloneCount = _cloneCount;
        _cloneCount.count += 1;
    }
    return newSprite;
}

- (void)dealloc
{
    self.cloneCount.count--;
}

@end
