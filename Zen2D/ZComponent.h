//
//  ZComponent.h
//  Zen2D
//
//  Created by Roger Cheng on 7/17/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZNode;

@interface ZComponent : NSObject <NSCopying>
@property (weak) id parentNode;
@property (assign) BOOL isActive;

- (void)cleanup;
- (void)attachedToNode;
- (void)reset;
- (void)activate;
- (void)deactivate;
- (void)update; //May need to pass delta time as well

@end
