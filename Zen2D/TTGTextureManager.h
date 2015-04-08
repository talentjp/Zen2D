//
//  TTGTextureManager.h
//  Zen2D
//
//  Created by Roger Cheng on 5/12/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class TTGTexture;

@interface TTGTextureManager : NSObject

@property (strong) NSMutableDictionary* dictTextures;

+ (TTGTextureManager*) sharedManager;

- (void) loadJSONSpriteSheet:(NSString*)sheetName;
- (void) loadImage:(NSString*)filename;
- (TTGTexture*) findTextureByFilename:(NSString*)filename;
@end
