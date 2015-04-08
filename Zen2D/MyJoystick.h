//
//  MyJoystick.h
//  Zen2D
//
//  Created by Roger Cheng on 6/2/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "TTGVirtualStick.h"
@class TTGSprite;

typedef enum{
    NOBLOCK_ENUM = 0,
    IBLOCK_ENUM = 1,
    JBLOCK_ENUM = 2,
    LBLOCK_ENUM = 3,
    OBLOCK_ENUM = 4,
    SBLOCK_ENUM = 5,
    TBLOCK_ENUM = 6,
    ZBLOCK_ENUM = 7
}TetrisBlockName;

@interface MyJoystick : TTGVirtualStick
{
    TetrisBlockName tetrisArray[20][10];
    TTGSprite* tetrisArrayIBlockPtr[20][10];
    TTGSprite* tetrisArrayJBlockPtr[20][10];
    TTGSprite* tetrisArrayLBlockPtr[20][10];
    TTGSprite* tetrisArrayOBlockPtr[20][10];
    TTGSprite* tetrisArraySBlockPtr[20][10];
    TTGSprite* tetrisArrayTBlockPtr[20][10];
    TTGSprite* tetrisArrayZBlockPtr[20][10];
    int _numOrientationsArray[8];
    TetrisBlockName _currentPiece;
    int _currentRotation;
    int _currentX; //0 ~ 9
    float _currentDropSpeed;
}

- (bool) queryBlockArrayForPiece:(TetrisBlockName)pieceName inRotation:(int)rotation Row:(int)row Col:(int)col;
- (float) getCurrentXPosition;
- (void) updateCurrentPieceLocation;
- (bool) detectCollisionAfterMoveBy:(int)x;
- (bool) detectCollisionAfterRotation;
- (int) getHigherY;
- (int) getLowerY;
- (void) updateCurrentPieceTexture;
- (void) removeCompletedRows;
- (void) gameOver;

@end
