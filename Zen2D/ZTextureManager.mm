//
//  ZTextureManager.m
//  Zen2D
//
//  Created by Roger Cheng on 5/12/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "ZTextureManager.h"
#import "ZTexture.h"

static ZTextureManager* singleton = nil;

@implementation ZTextureManager

@synthesize dictTextures = _dictTextures;

+ (ZTextureManager *)sharedManager
{
    @synchronized(singleton)
    {
        if(!singleton)
        {
            singleton = [[ZTextureManager alloc] init];
        }
    }
    return singleton;
}

- (id)init
{
    if((self = [super init]))
    {
        singleton = self;
        _dictTextures = [NSMutableDictionary dictionary];
        
    }
    return singleton;
}

- (void)loadJSONSpriteSheet:(NSString *)sheetName
{
    NSError* jsonError = nil;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:sheetName ofType:nil];
    NSData* jsonData = [NSData dataWithContentsOfFile:filePath];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jsonError];
    if(jsonError)
    {
        NSLog(@"Error reading JSON file : %@", jsonError);
    }
    else{
        NSString* imageName = [[jsonObject objectForKey:@"meta"] objectForKey:@"image"];
        //Load image into a UIImage
        UIImage* image = [UIImage imageNamed:imageName];
        //Extract the alpha from the CGImage
        CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
        const UInt8* data = CFDataGetBytePtr(pixelData);
        //Load CGImage into a texture
        NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
        NSError* texError;
        GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:&texError];
        if(!textureInfo)
        {
            NSLog(@"Error loading file %@", [texError localizedDescription]);
        }
        
        NSArray* jsonArray = [jsonObject objectForKey:@"frames"];
        for(id jsonElement in jsonArray)
        {
            //NSLog(@"filename : %@", [jsonElement objectForKey:@"filename"]);
            ZTexture* newTexture = [[ZTexture alloc] initWithTextureInfo:textureInfo];
            NSDictionary* frame = [jsonElement objectForKey:@"frame"];
            BOOL rotated = [[jsonElement objectForKey:@"rotated"] boolValue];
            BOOL trimmed = [[jsonElement objectForKey:@"trimmed"] boolValue];
            NSDictionary* spriteSourceSize = [jsonElement objectForKey:@"spriteSourceSize"];
            NSDictionary* sourceSize = [jsonElement objectForKey:@"sourceSize"];
            
            newTexture.spriteCoordInTexture = CGPointMake([[frame objectForKey:@"x"] integerValue],
                                                          [[frame objectForKey:@"y"] integerValue]);
            
            newTexture.spriteSize = CGSizeMake([[frame objectForKey:@"w"] integerValue],
                                                [[frame objectForKey:@"h"] integerValue]);
            
            int xOffset = newTexture.spriteCoordInTexture.x;
            int yOffset = newTexture.spriteCoordInTexture.y;
            int textureWidth = newTexture.textureInfo.width;
            
            int spriteHeight = newTexture.spriteSize.height;
            int spriteWidth = newTexture.spriteSize.width;
            
            for(int row = 0; row < spriteHeight; row++)
            {
                for(int col = 0; col < spriteWidth; col++)
                {
                    int indexInTexture = xOffset + col + textureWidth * (yOffset + row);
                    [newTexture addAlphaValue:data[indexInTexture * 4 + 3]];
                }
            }
            
            newTexture.trimmed    = trimmed;
            newTexture.rotated    = rotated;
            newTexture.sourceSpriteCoord = CGPointMake([[spriteSourceSize objectForKey:@"x"] integerValue],
                                                       [[spriteSourceSize objectForKey:@"y"] integerValue]);
            
            newTexture.sourceSpriteSize = CGSizeMake([[spriteSourceSize objectForKey:@"w"] integerValue],
                                                      [[spriteSourceSize objectForKey:@"h"] integerValue]);
            
            newTexture.sourceImgSize = CGSizeMake([[sourceSize objectForKey:@"w"] integerValue],
                                                  [[sourceSize objectForKey:@"h"] integerValue]);
            
            [_dictTextures setObject:newTexture forKey:[jsonElement objectForKey:@"filename"]];
        }
        CFRelease(pixelData);
        }
}

- (void)loadImage:(NSString *)filename
{
    if([_dictTextures objectForKey:filename])
    {
        //NSLog(@"Image is already loaded");
    }
    else
    {
        UIImage* image = [UIImage imageNamed:filename];
        CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
        const UInt8* data = CFDataGetBytePtr(pixelData);
        NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft, nil];
        NSError* texError;
        GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:options error:&texError];
        if(!textureInfo)
        {
            NSLog(@"Error loading file %@", [texError localizedDescription]);
        }
        
        ZTexture* newTexture = [[ZTexture alloc] initWithTextureInfo:textureInfo];
        newTexture.spriteSize = newTexture.sourceSpriteSize = newTexture.sourceImgSize =
        CGSizeMake(textureInfo.width, textureInfo.height);
        
        [_dictTextures setObject:newTexture forKey:filename];
        //Save the alpha info to texture object

        
        NSLog(@"image size (%f,%f)", image.size.width, image.size.height);
        for(int i = 0; i < image.size.width * image.size.height; i++ )
        {
            [newTexture addAlphaValue:data[i * 4 + 3]];
        }
        CFRelease(pixelData);
    }
}

- (ZTexture *)findTextureByFilename:(NSString *)filename
{
    return [_dictTextures objectForKey:filename];
}

@end
