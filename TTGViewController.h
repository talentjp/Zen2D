//
//  TTGViewController.h
//  Zen2D
//
//  Created by Roger Cheng on 4/20/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "TTGSprite.h"
#import "TTGScene.h"

@interface TTGViewController : GLKViewController
@property (strong, nonatomic) EAGLContext *context;
@end
