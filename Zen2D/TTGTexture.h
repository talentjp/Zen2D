//
//  TTGTexture.h
//  Zen2D
//
//  Created by Roger Cheng on 5/18/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLKit/GLKit.h"
#include <vector>

@interface TTGTexture : NSObject
{
    std::vector<UInt8> _vecAlphaValues;
}
@property (strong) GLKTextureInfo* textureInfo;
@property (assign) CGPoint spriteCoordInTexture;
@property (assign) CGSize  spriteSize;
@property (assign) BOOL    rotated;
@property (assign) BOOL    trimmed;
@property (assign) CGPoint sourceSpriteCoord;
@property (assign) CGSize  sourceSpriteSize;
@property (assign) CGSize  sourceImgSize;

- (id)initWithTextureInfo:(GLKTextureInfo*) info;
- (UInt8)getAlphaValueAtIndex:(int) index;
- (BOOL)isPixelTransparentAtX:(int)x Y:(int)y;
- (void)addAlphaValue:(UInt8)alphaVal;

@end
