//
//  ZText.m
//  Zen2D
//
//  Created by Roger Cheng on 5/5/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZText.h"
#import "ZTextureManager.h"
#import "ZTexture.h"

@implementation ZText

@synthesize frontLabel = _frontLabel;
@synthesize backLabel = _backLabel;
@synthesize labelView = _labelView;
@synthesize trimTopSpace = _trimTopSpace;
@synthesize trimBottomSpace = _trimBottomSpace;

- (id)initWithString:(NSString *)text
{
    if((self = [super init]))
    {
        self.isTextureCloned = NO;
        _trimTopSpace = 0;
        _trimBottomSpace = 0;
        _backLabel = [[UILabel alloc] init];
        _frontLabel = [[UILabel alloc] init];
        _labelView = [[UIView alloc] init];
        [_backLabel setBackgroundColor:[UIColor clearColor]];
        [_frontLabel setTextColor:[UIColor whiteColor]];
        [_frontLabel setBackgroundColor:[UIColor clearColor]];
        [_frontLabel setText:text];
        [_frontLabel setNumberOfLines:1];
        [_frontLabel sizeToFit];
        _isViewFrameDirty = YES;
        [_labelView addSubview:_backLabel];
        [_labelView addSubview:_frontLabel];
        _isTextureDirty = YES;
        self.touchMode = TOUCH_MODE_INSIDE;
    }
    return self;
}


//This is the init without anything in it (for compliance with copyWithZone:)
- (id)init
{
    if((self = [super init]))
    {
        self.isTextureCloned = NO;
        _isTextureDirty = NO;
        _isViewFrameDirty = NO;
        _trimTopSpace = 0;
        _trimBottomSpace = 0;
        _backLabel = [[UILabel alloc] init];
        _frontLabel = [[UILabel alloc] init];
        _labelView = [[UIView alloc] init];
        [_labelView addSubview:_backLabel];
        [_labelView addSubview:_frontLabel];
        self.touchMode = TOUCH_MODE_INSIDE;
    }
    return self;
}

- (void)setBackGroundColor:(UIColor *)color
{
    _backLabel.backgroundColor = color;
    _isTextureDirty = YES;
}


- (void)updateViewFrame
{
    [_labelView setFrame:CGRectMake(0, 0, _frontLabel.frame.size.width, _frontLabel.frame.size.height - _trimBottomSpace - _trimTopSpace)];
    CGRect baseFrame = CGRectMake(0, 0, _labelView.frame.size.width, _labelView.frame.size.height);
    [_backLabel setFrame:baseFrame];
    [_frontLabel setFrame:CGRectMake(0, -_trimTopSpace, _frontLabel.frame.size.width, _frontLabel.frame.size.height)];
}


- (void)setText:(NSString *)text
{
    if(![_frontLabel.text isEqualToString:text])
    {    
        [_frontLabel removeFromSuperview];
        [_frontLabel setText:text];
        //Need to recalculate size based on new text
        [_frontLabel sizeToFit];
        _isViewFrameDirty = YES;
        [_labelView addSubview:_frontLabel];
        _isTextureDirty = YES;
    }
}

- (void)setTextColor:(UIColor *)color
{
    [_frontLabel setTextColor:color];
    _isTextureDirty = YES;
}

- (void)setFont:(UIFont *)font
{
    [_frontLabel removeFromSuperview];
    [_frontLabel setFont:font];
    //Need to recalculate size based on new font
    [_frontLabel sizeToFit];
    _isViewFrameDirty = YES;
    [_labelView addSubview:_frontLabel];
    _isTextureDirty = YES;
}

- (void)trimTopMargin:(float)pixels
{
    _trimTopSpace = pixels;
    _isViewFrameDirty = YES;
    _isTextureDirty = YES;
}

- (void)trimBottomMargin:(float)pixels
{
    _trimBottomSpace = pixels;
    _isViewFrameDirty = YES;
    _isTextureDirty = YES;
}

- (void)roundTheCornersWithRadius:(float)radius
{
    _backLabel.layer.cornerRadius= radius;
    [_backLabel.layer setMasksToBounds:YES];
    //_labelView.layer.cornerRadius = radius;
    _isViewFrameDirty = YES;
    _isTextureDirty = YES;
}

- (void)render
{
    [self checkUpdates];
    [super render];
}

- (void)checkUpdates
{
    if(_isViewFrameDirty)
    {
        [self updateViewFrame];
        _isViewFrameDirty = NO;
    }
    if(_isTextureDirty)
    {
        [self updateTexture];
        _isTextureDirty = NO;
    }
}

- (void)updateTexture
{
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                             GLKTextureLoaderOriginBottomLeft, nil];
    NSError* error;
    UIGraphicsBeginImageContext(_labelView.frame.size);
    [[_labelView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //Only release the texture if clone count is 0
    if(self.texture && self.cloneCount.count == 0)
    {
        GLuint texture_name = self.texture.textureInfo.name;
        glDeleteTextures(1, &texture_name);
    }
    
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:theImage.CGImage options:options error:&error];
    if(!textureInfo)
    {
        NSLog(@"Error loading file %@", [error localizedDescription]);
    }
    
    ZTexture* newTexture = [[ZTexture alloc] initWithTextureInfo:textureInfo];
    self.spriteSize = newTexture.sourceSpriteSize = newTexture.spriteSize = newTexture.sourceImgSize  =
    CGSizeMake(textureInfo.width, textureInfo.height);
    self.texture = newTexture;
    self.cloneCount.count--;
    self.cloneCount = [[TTGReferenceCounter alloc] init];
    TextureQuad newQuad;
    int width = textureInfo.width;
    int height = textureInfo.height;
    newQuad.bl.geometryVertex = CGPointMake32(-width / 2.0, -height / 2.0);
    newQuad.br.geometryVertex = CGPointMake32(width / 2.0, -height / 2.0);
    newQuad.tl.geometryVertex = CGPointMake32(-width / 2.0, height / 2.0);
    newQuad.tr.geometryVertex = CGPointMake32(width / 2.0, height / 2.0);
    
    newQuad.bl.textureVertex = CGPointMake32(0, 0);
    newQuad.br.textureVertex = CGPointMake32(1, 0);
    newQuad.tl.textureVertex = CGPointMake32(0, 1);
    newQuad.tr.textureVertex = CGPointMake32(1, 1);
    self.quad = newQuad;
}

- (BOOL)isLocationWithinSprite:(CGPoint)location
{
    //Easiest approach, simply inverse transform the touch point with the current model view matrix and compare
    GLKVector4 touchPoint = GLKVector4Make(location.x, location.y, 0, 1);
    GLKVector4 trans_touch = GLKMatrix4MultiplyVector4(GLKMatrix4Invert(_modelViewMat, nil), touchPoint);
    //Reject immediately if it falls outside the sprite
    if(trans_touch.x > self.spriteSize.width / 2.0 || trans_touch.x < -self.spriteSize.width / 2.0 || trans_touch.y > self.spriteSize.height / 2.0 || trans_touch.y < -self.spriteSize.height / 2.0)
    {
        return NO;
    }
    //For text anything within bound is valid
    return YES;
}

- (id)copyWithZone:(NSZone *)zone
{
    [self checkUpdates];
    ZText* newText = [super copyWithZone:zone];
    if(newText)
    {
        newText.backLabel.backgroundColor = _backLabel.backgroundColor;
        newText.backLabel.frame = _backLabel.frame;
        newText.backLabel.layer.cornerRadius = _backLabel.layer.cornerRadius;
        newText.frontLabel.text = _frontLabel.text;
        newText.frontLabel.font = _frontLabel.font;
        newText.frontLabel.textColor = _frontLabel.textColor;
        newText.frontLabel.numberOfLines = _frontLabel.numberOfLines;
        newText.frontLabel.backgroundColor = _frontLabel.backgroundColor;
        newText.frontLabel.frame = _frontLabel.frame;
        newText.labelView.frame = _labelView.frame;
        newText.trimTopSpace = _trimTopSpace;
        newText.trimBottomSpace = _trimBottomSpace;
    }
    return newText;
}

@end
