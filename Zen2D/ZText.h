//
//  ZText.h
//  Zen2D
//
//  Created by Roger Cheng on 5/5/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZSprite.h"
#import <QuartzCore/QuartzCore.h>

@interface ZText : ZSprite
{
    bool _isTextureDirty;
    bool _isViewFrameDirty;
}
@property (strong) UILabel* frontLabel;
@property (strong) UILabel* backLabel;
@property (strong) UIView* labelView;
@property (assign) float trimBottomSpace;
@property (assign) float trimTopSpace;

- (id)initWithString:(NSString*)text;
- (void)setBackGroundColor:(UIColor*)color;
- (void)setTextColor:(UIColor*)color;
- (void)setText:(NSString*)text;
- (void)setFont:(UIFont*)font;
- (void)trimTopMargin:(float)pixels;
- (void)trimBottomMargin:(float)pixels;
- (void)roundTheCornersWithRadius:(float)radius;
- (void)updateTexture; //Re-render the texture from UILabel
- (void)updateViewFrame; //Calculate new frame sizes for the UILabel
- (void)checkUpdates;

@end
