//
//  TTGMovingText.h
//  Zen2D
//
//  Created by Roger Cheng on 5/9/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGText.h"
@class TTGTouchComponent;

@interface TouchableText : TTGText
{
    TTGTouchComponent* _touchComp;
}

@end
