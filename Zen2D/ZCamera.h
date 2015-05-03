//
//  ZCamera.h
//  Zen2D
//
//  Created by Roger Cheng on 9/22/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZNode.h"

@interface ZCamera : ZNode

@property (assign) CGSize cameraSize;

- (id)initWithWidth:(float)width Height:(float)height;
- (GLKMatrix4) getCameraMatrix;

@end
