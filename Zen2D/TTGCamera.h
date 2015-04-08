//
//  TTGCamera.h
//  Zen2D
//
//  Created by Roger Cheng on 9/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGNode.h"

@interface TTGCamera : TTGNode

@property (assign) CGSize cameraSize;

- (id)initWithWidth:(float)width Height:(float)height;
- (GLKMatrix4) getCameraMatrix;

@end
