//
//  TTGCamera.m
//  Zen2D
//
//  Created by Roger Cheng on 9/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGCamera.h"
#import "TTGDeviceManager.h"

@implementation TTGCamera
@synthesize cameraSize = _cameraSize;


- (id)init
{
    if((self = [super init]))
    {
        float width = [[TTGDeviceManager sharedManager] getScreenWidth];
        float height = [[TTGDeviceManager sharedManager] getScreenHeight];
        _cameraSize = CGSizeMake(width, height);
        self.spritePosition = CGPointMake(width/2.0, height/2.0);
    }
    return self;
}

- (id)initWithWidth:(float)width Height:(float)height
{
    if((self = [super init]))
    {
        _cameraSize = CGSizeMake(width, height);
        self.spritePosition = CGPointMake(width/2.0, height/2.0);
    }
    return self;
}

-(GLKMatrix4)getCameraMatrix
{
    _modelViewMat = GLKMatrix4Translate(GLKMatrix4Identity, _cameraSize.width - (int)self.spritePosition.x, _cameraSize.height - (int)self.spritePosition.y, 0);
    _modelViewMat = GLKMatrix4RotateZ(_modelViewMat, GLKMathDegreesToRadians(-self.rotation));
    _modelViewMat = GLKMatrix4Scale(_modelViewMat, 1.0 / self.scale.width, 1.0 / self.scale.height, 1.0);
    _modelViewMat = GLKMatrix4Translate(_modelViewMat, -_cameraSize.width/2.0 , -_cameraSize.height/2.0, 0);
    return _modelViewMat;
}

@end
