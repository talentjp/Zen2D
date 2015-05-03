//
//  ZViewController.m
//  Zen2D
//
//  Created by Roger Cheng on 4/20/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZViewController.h"
#import "ZTouchManager.h"
#import "ZSceneManager.h"
//Demo Scene
#import "SceneSelectScene.h"

@implementation ZViewController
@synthesize context;

- (void)viewDidLoad
{
    [super viewDidLoad];
    GLKView* view = (GLKView*) self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if(!view.context)
    {
        NSLog(@"Failed to create ES context");
    }
    [EAGLContext setCurrentContext:view.context];
    //Demo Scene
    [[ZSceneManager sharedManager] switchToScene:[[SceneSelectScene alloc] init]];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(0, 0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    [[ZSceneManager sharedManager] renderScene];
}

- (void)update
{
    [[ZSceneManager sharedManager] updateWithTime:self.timeSinceLastUpdate];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[ZTouchManager sharedManager] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[ZTouchManager sharedManager] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[ZTouchManager sharedManager] touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Treat cancelled as ended for simplicity
    [[ZTouchManager sharedManager] touchesEnded:touches withEvent:event];
}

@end
