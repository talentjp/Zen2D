//
//  ZSprite.h
//  Zen2D
//
//  Created by Roger Cheng on 4/20/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZNode.h"
#import "ZTextureManager.h"

@interface TTGReferenceCounter : NSObject
@property (assign) int count;
@end


//Workaround for GLFloat in 64-bit as somehow the shader program only accepts 32-bit floats
//CGPoint32 and CGPointMake32 are borrowed from Apple definitions
struct CGPoint32 {
    GLfloat x;
    GLfloat y;
};
typedef struct CGPoint32 CGPoint32;


CG_INLINE CGPoint32
CGPointMake32(GLfloat x, GLfloat y)
{
    CGPoint32 p; p.x = x; p.y = y; return p;
}


typedef struct{
    CGPoint32 geometryVertex;
    CGPoint32 textureVertex;
}TextureVertex;

typedef struct{
    TextureVertex bl;
    TextureVertex br;
    TextureVertex tl;
    TextureVertex tr;
}TextureQuad;

@interface ZSprite : ZNode
@property (assign) TextureQuad            quad;
@property (strong) ZTexture*            texture;
@property (assign) CGSize                 spriteSize;
@property (assign) float                  spriteDepth;
@property (assign) bool                   isTextureCloned;
@property (strong) TTGReferenceCounter*   cloneCount;

- (id)initWithFile:(NSString*) fileName;

@end
