//
//  ZTextureManager.h
//  Zen2D
//
//  Created by Roger Cheng on 5/12/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class ZTexture;

@interface ZTextureManager : NSObject

@property (strong) NSMutableDictionary* dictTextures;

+ (ZTextureManager*) sharedManager;

- (void) loadJSONSpriteSheet:(NSString*)sheetName;
- (void) loadImage:(NSString*)filename;
- (ZTexture*) findTextureByFilename:(NSString*)filename;
@end
