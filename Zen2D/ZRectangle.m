//
//  ZRectangle.m
//  Zen2D
//
//  Created by Roger Cheng on 8/5/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZRectangle.h"

@implementation ZRectangle
@synthesize solidColor = _solidColor;

- (id)init
{
    if((self = [super init]))
    {
        _solidColor = [UIColor whiteColor];
        self.touchMode = TOUCH_MODE_INSIDE;
    }
    return self;
}

- (void)render
{
    if(!self.hide)
    {
        GLfloat rect[] = {
            -self.spriteSize.width / 2.0, -self.spriteSize.height / 2.0,
            self.spriteSize.width / 2.0, -self.spriteSize.height / 2.0,
            -self.spriteSize.width / 2.0, self.spriteSize.height / 2.0,
            self.spriteSize.width / 2.0, self.spriteSize.height / 2.0
        };
        self.effect.texture2d0.enabled = NO;
        CGFloat r = 1,g = 1,b = 1,a = 1;
        [_solidColor getRed:&r green:&g blue:&b alpha:&a];
        self.effect.constantColor = GLKVector4Make(r,g,b,self.opacity);
        self.effect.useConstantColor = YES;
        self.effect.transform.modelviewMatrix = _modelViewMat;
        [self.effect prepareToDraw];
        glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 2, rect);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
}


@end
