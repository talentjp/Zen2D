//
//  ZTexture.m
//  Zen2D
//
//  Created by Roger Cheng on 5/18/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZTexture.h"
#import "GLKit/GLKit.h"

@implementation ZTexture

@synthesize textureInfo          = _textureInfo;
@synthesize spriteCoordInTexture = _spriteCoordInTexture;
@synthesize spriteSize           = _spriteSize;
@synthesize rotated              = _rotated;
@synthesize trimmed              = _trimmed;
@synthesize sourceSpriteCoord    = _sourceSpriteCoord;
@synthesize sourceSpriteSize     = _sourceSpriteSize;
@synthesize sourceImgSize        = _sourceImgSize;

- (id)initWithTextureInfo:(GLKTextureInfo*) info;
{
    if((self = [super init]))
    {
        _textureInfo = info;
        _spriteCoordInTexture = CGPointMake(0, 0);
        _spriteSize           = CGSizeMake(0, 0);
        _rotated = NO;
        _trimmed = NO;
        _sourceSpriteCoord    = CGPointMake(0, 0);
        _sourceSpriteSize     = CGSizeMake(0, 0);
        _sourceImgSize        = CGSizeMake(0, 0);
    }
    return self;
}

- (NSString *)description
{
    NSString* descString = [NSString stringWithFormat:@"<ZTexture>{ Sprite Coordinates:(%f, %f)\r \
                            Sprite Size:(%f, %f),\r \
                            Rotated:%d, Trimmed:%d,\r \
                            SpriteSourceSize(%f,%f,%f,%f),\r \
                            SourceSize:(%f, %f) }",
                            _spriteCoordInTexture.x, _spriteCoordInTexture.y, _spriteSize.width, _spriteSize.height,
                            _rotated, _trimmed, _sourceSpriteCoord.x, _sourceSpriteCoord.y, _sourceSpriteSize.width,
                            _sourceSpriteSize.height, _sourceImgSize.width, _sourceImgSize.height];
    return descString;
}

- (UInt8)getAlphaValueAtIndex:(int)index
{
    if(index < _vecAlphaValues.size())
    {
        return _vecAlphaValues[index];
    }
    NSLog(@"Someone is trying to access an invalid element in the alpha array!");
    return 0xff;
}

- (BOOL)isPixelTransparentAtX:(int)x Y:(int)y
{
    if(x < 0 || y < 0 || x > _spriteSize.width - 1 || y > _spriteSize.height - 1) //We can't allow an out-of-bound access
    {
        return YES;
    }
    else if( _vecAlphaValues[((int)_spriteSize.height - 1 - y) * (int)_spriteSize.width + x] == 0)
    {
        return YES;
    }
    return NO;
}

- (void)addAlphaValue:(UInt8)alphaVal
{
    _vecAlphaValues.push_back(alphaVal);
}

@end