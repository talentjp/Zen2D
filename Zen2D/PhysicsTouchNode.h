//
//  PhysicsTouchNode.h
//  Zen2D
//
//  Created by Roger Cheng on 10/15/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGNode.h"
@class TTGTouchComponent;
@interface PhysicsTouchNode : TTGNode
{
    TTGTouchComponent* _touchComp;
}
@end
