//
//  MyJoystick.m
//  Zen2D
//
//  Created by Roger Cheng on 6/2/13.
//  Copyright (c) 2013 Roger Cheng. All rights reserved.
//

#import "MyJoystick.h"
#import "TTGSprite.h"
#import "TTGScene.h"

//Square
bool OPiece[4][4] = {
    {0,0,0,0},
    {0,1,1,0},
    {0,1,1,0},
    {0,0,0,0}
};

//Bar
bool IPiece1[4][4] = {
    {0,0,0,0},
    {0,0,0,0},
    {1,1,1,1},
    {0,0,0,0}
};

bool IPiece2[4][4] ={
    {0,0,1,0},
    {0,0,1,0},
    {0,0,1,0},
    {0,0,1,0}
};

//S
bool SPiece1[4][4] = {
    {0,0,0,0},
    {0,1,1,0},
    {0,0,1,1},
    {0,0,0,0}
};

bool SPiece2[4][4] ={
    {0,0,0,0},
    {0,0,0,1},
    {0,0,1,1},
    {0,0,1,0}
};

//Z
bool ZPiece1[4][4] = {
    {0,0,0,0},
    {0,0,1,1},
    {0,1,1,0},
    {0,0,0,0}
};

bool ZPiece2[4][4] ={
    {0,0,0,0},
    {0,0,1,0},
    {0,0,1,1},
    {0,0,0,1}
};

//L
bool LPiece1[4][4] = {
    {0,0,0,0},
    {0,1,0,0},
    {0,1,1,1},
    {0,0,0,0}
};

bool LPiece2[4][4] = {
    {0,0,0,0},
    {0,0,1,1},
    {0,0,1,0},
    {0,0,1,0}
};
bool LPiece3[4][4] = {
    {0,0,0,0},
    {0,0,0,0},
    {0,1,1,1},
    {0,0,0,1}
};
bool LPiece4[4][4] = {
    {0,0,0,0},
    {0,0,1,0},
    {0,0,1,0},
    {0,1,1,0}
};

//J
bool JPiece1[4][4] = {
    {0,0,0,0},
    {0,0,0,1},
    {0,1,1,1},
    {0,0,0,0}
};

bool JPiece2[4][4] = {
    {0,0,0,0},
    {0,0,1,0},
    {0,0,1,0},
    {0,0,1,1}
};
bool JPiece3[4][4] = {
    {0,0,0,0},
    {0,0,0,0},
    {0,1,1,1},
    {0,1,0,0}
};
bool JPiece4[4][4] = {
    {0,0,0,0},
    {0,1,1,0},
    {0,0,1,0},
    {0,0,1,0}
};

//T
bool TPiece1[4][4] = {
    {0,0,0,0},
    {0,0,1,0},
    {0,1,1,1},
    {0,0,0,0}
};

bool TPiece2[4][4] = {
    {0,0,0,0},
    {0,0,1,0},
    {0,0,1,1},
    {0,0,1,0}
};
bool TPiece3[4][4] = {
    {0,0,0,0},
    {0,0,0,0},
    {0,1,1,1},
    {0,0,1,0}
};
bool TPiece4[4][4] = {
    {0,0,0,0},
    {0,0,1,0},
    {0,1,1,0},
    {0,0,1,0}
};


@implementation MyJoystick

- (id)init
{
    if((self = [super init]))
    {
        _currentDropSpeed = 40.0;
        
        _numOrientationsArray[NOBLOCK_ENUM] = 0;
        _numOrientationsArray[OBLOCK_ENUM] = 1;
        _numOrientationsArray[IBLOCK_ENUM] = 2;
        _numOrientationsArray[SBLOCK_ENUM] = 2;
        _numOrientationsArray[ZBLOCK_ENUM] = 2;
        _numOrientationsArray[LBLOCK_ENUM] = 4;
        _numOrientationsArray[JBLOCK_ENUM] = 4;
        _numOrientationsArray[TBLOCK_ENUM] = 4;
        
        _currentPiece = arc4random() % 7 + 1;
        _currentRotation = 0;
        _currentX = 4;
        
        TTGNode* pieceNode = [[TTGNode alloc] init];
        pieceNode.identifier = @"TetrisPiece";
        [self attachNode:pieceNode];
        pieceNode.scale = CGSizeMake(1.0, 1.0);
        pieceNode.spritePosition = CGPointMake([self getCurrentXPosition], 320);
        
        [self updateCurrentPieceTexture];
        
        //Pre-load the background with fixed blocks to toggle hidden
        for(int row= 0; row < 20; row++)
        {
            for(int col = 0; col < 10; col++)
            {
                TTGSprite* tetrisBlock = [[TTGSprite alloc] initWithFile:@"IBlock.png"];
                [self attachNode:tetrisBlock];
                tetrisBlock.spritePosition = CGPointMake(col * 16 + 8 + 160, row * 16 + 8);
                tetrisBlock.spriteDepth = -1;
                tetrisBlock.hide = YES;
                tetrisArrayIBlockPtr[row][col] = tetrisBlock;
                
                tetrisBlock = [[TTGSprite alloc] initWithFile:@"JBlock.png"];
                [self attachNode:tetrisBlock];
                tetrisBlock.spritePosition = CGPointMake(col * 16 + 8 + 160, row * 16 + 8);
                tetrisBlock.spriteDepth = -1;
                tetrisBlock.hide = YES;
                tetrisArrayJBlockPtr[row][col] = tetrisBlock;
                
                tetrisBlock = [[TTGSprite alloc] initWithFile:@"LBlock.png"];
                [self attachNode:tetrisBlock];
                tetrisBlock.spritePosition = CGPointMake(col * 16 + 8 + 160, row * 16 + 8);
                tetrisBlock.spriteDepth = -1;
                tetrisBlock.hide = YES;
                tetrisArrayLBlockPtr[row][col] = tetrisBlock;
                
                tetrisBlock = [[TTGSprite alloc] initWithFile:@"OBlock.png"];
                [self attachNode:tetrisBlock];
                tetrisBlock.spritePosition = CGPointMake(col * 16 + 8 + 160, row * 16 + 8);
                tetrisBlock.spriteDepth = -1;
                tetrisBlock.hide = YES;
                tetrisArrayOBlockPtr[row][col] = tetrisBlock;
                
                tetrisBlock = [[TTGSprite alloc] initWithFile:@"SBlock.png"];
                [self attachNode:tetrisBlock];
                tetrisBlock.spritePosition = CGPointMake(col * 16 + 8 + 160, row * 16 + 8);
                tetrisBlock.spriteDepth = -1;
                tetrisBlock.hide = YES;
                tetrisArraySBlockPtr[row][col] = tetrisBlock;
                
                tetrisBlock = [[TTGSprite alloc] initWithFile:@"TBlock.png"];
                [self attachNode:tetrisBlock];
                tetrisBlock.spritePosition = CGPointMake(col * 16 + 8 + 160, row * 16 + 8);
                tetrisBlock.spriteDepth = -1;
                tetrisBlock.hide = YES;
                tetrisArrayTBlockPtr[row][col] = tetrisBlock;
                
                tetrisBlock = [[TTGSprite alloc] initWithFile:@"ZBlock.png"];
                [self attachNode:tetrisBlock];
                tetrisBlock.spritePosition = CGPointMake(col * 16 + 8 + 160, row * 16 + 8);
                tetrisBlock.spriteDepth = -1;
                tetrisBlock.hide = YES;
                tetrisArrayZBlockPtr[row][col] = tetrisBlock;
                tetrisArray[row][col] = NOBLOCK_ENUM;
            }
        }
    }
    return self;
}


- (void)buttonAPressed
{
    if(![self detectCollisionAfterRotation])
    {
        _currentRotation = (_currentRotation + 1) % _numOrientationsArray[_currentPiece];
    }
    
    [self updateCurrentPieceTexture];
}

- (void)leftAnalogDown
{
    if(self.leftAnalogPosition.x > 0.3)
    {
        _currentX = [self detectCollisionAfterMoveBy:1] ? _currentX : _currentX + 1;
    }
    else if(self.leftAnalogPosition.x < -0.3)
    {
        _currentX = [self detectCollisionAfterMoveBy:-1] ? _currentX : _currentX - 1;
    }
    [self updateCurrentPieceLocation];
    
    if(self.leftAnalogPosition.y < -0.5)
    {
        _currentDropSpeed = 200;
    }
}

- (void)updateCurrentPieceLocation
{
    TTGNode* theNode = [self findNodeByIdentifier:@"TetrisPiece"];
    [theNode moveToX:[self getCurrentXPosition] Y:theNode.spritePosition.y];
}

- (void)updateCurrentPieceTexture
{
    [[self findNodeByIdentifier:@"Block1"] destroy];
    [[self findNodeByIdentifier:@"Block2"] destroy];
    [[self findNodeByIdentifier:@"Block3"] destroy];
    [[self findNodeByIdentifier:@"Block4"] destroy];
    
    TTGNode* theNode = [self findNodeByIdentifier:@"TetrisPiece"];
    
    NSString* blockString = nil;
    
    if(_currentPiece == IBLOCK_ENUM)
    {
        blockString = @"IBlock.png";
    }
    else if(_currentPiece == JBLOCK_ENUM)
    {
        blockString = @"JBlock.png";
    }
    else if(_currentPiece == LBLOCK_ENUM)
    {
        blockString = @"LBlock.png";
    }
    else if(_currentPiece == OBLOCK_ENUM)
    {
        blockString = @"OBlock.png";
    }
    else if(_currentPiece == SBLOCK_ENUM)
    {
        blockString = @"SBlock.png";
    }
    else if(_currentPiece == TBLOCK_ENUM)
    {
        blockString = @"TBlock.png";
    }
    else if(_currentPiece == ZBLOCK_ENUM)
    {
        blockString = @"ZBlock.png";
    }
    
    TTGSprite* pieceBlock1 = [[TTGSprite alloc] initWithFile:blockString];
    TTGSprite* pieceBlock2 = [[TTGSprite alloc] initWithFile:blockString];
    TTGSprite* pieceBlock3 = [[TTGSprite alloc] initWithFile:blockString];
    TTGSprite* pieceBlock4 = [[TTGSprite alloc] initWithFile:blockString];
    
    pieceBlock1.identifier = @"Block1";
    pieceBlock2.identifier = @"Block2";
    pieceBlock3.identifier = @"Block3";
    pieceBlock4.identifier = @"Block4";
    
    [theNode attachNode:pieceBlock1];
    [theNode attachNode:pieceBlock2];
    [theNode attachNode:pieceBlock3];
    [theNode attachNode:pieceBlock4];
    
    int blockCount = 0;
    for(int row = 0; row < 4; row++)
    {
        for(int col = 0; col < 4;col++)
        {
            if([self queryBlockArrayForPiece:_currentPiece inRotation:_currentRotation Row:row Col:col])
            {
                blockCount++;
                TTGNode* block = [self findNodeByIdentifier:[NSString stringWithFormat:@"Block%d", blockCount]];
                block.spritePosition = CGPointMake((col-2) * 16, (row-2) * 16);
            }
        }
    }
}

- (bool)detectCollisionAfterMoveBy:(int)x
{
    int lowerYIdx  = [self getLowerY];
    int higherYIdx = [self getHigherY];
    for(int row = 0; row < 4; row++)
    {
        for(int col = 0; col < 4;col++)
        {
            if([self queryBlockArrayForPiece:_currentPiece inRotation:_currentRotation Row:row Col:col])
            {
                int curBlockX = _currentX + x + col - 2;
                int curBlockYLower = lowerYIdx + row - 2;
                int curBlockYHigher = higherYIdx + row - 2;
             
                //Collision with walls
                if(curBlockX > 9 || curBlockX < 0)
                {
                    return YES;
                }
                
                //Collision with blocks
                if(curBlockYLower >= 0 && curBlockYLower <= 19)
                {
                    if(tetrisArray[curBlockYLower][curBlockX] != NOBLOCK_ENUM)
                    {
                        return YES;
                    }
                }
                
                if(curBlockYHigher >= 0 && curBlockYHigher <= 19)
                {
                    if(tetrisArray[curBlockYHigher][curBlockX] != NOBLOCK_ENUM)
                    {
                        return YES;
                    }
                }
            }
        }
    }
    
    return NO;
}

- (bool)detectCollisionAfterRotation
{
    int lowerYIdx  = [self getLowerY];
    int higherYIdx = [self getHigherY];
    for(int row = 0; row < 4; row++)
    {
        for(int col = 0; col < 4;col++)
        {
            if([self queryBlockArrayForPiece:_currentPiece inRotation:((_currentRotation + 1) % _numOrientationsArray[_currentPiece]) Row:row Col:col])
            {
                int curBlockX = _currentX + col - 2;
                int curBlockYLower = lowerYIdx + row - 2;
                int curBlockYHigher = higherYIdx + row - 2;
                
                //Collision with walls
                if(curBlockX > 9 || curBlockX < 0)
                {
                    return YES;
                }
                
                //Collision with blocks
                if(curBlockYLower >= 0 && curBlockYLower <= 19)
                {
                    if(tetrisArray[curBlockYLower][curBlockX] != NOBLOCK_ENUM)
                    {
                        return YES;
                    }
                }
                
                if(curBlockYHigher >= 0 && curBlockYHigher <= 19)
                {
                    if(tetrisArray[curBlockYHigher][curBlockX] != NOBLOCK_ENUM)
                    {
                        return YES;
                    }
                }
            }
        }
    }    
    return NO;
}

- (int)getLowerY
{
    TTGNode* theNode = [self findNodeByIdentifier:@"TetrisPiece"];
    float yPosition = theNode.spritePosition.y;
    int yIdx =  floor((yPosition - 8.0) / 16.0);
    return yIdx;
}

- (int)getHigherY
{
    TTGNode* theNode = [self findNodeByIdentifier:@"TetrisPiece"];
    float yPosition = theNode.spritePosition.y;
    int yIdx = floor((yPosition + 8.0) / 16.0);
    if(yIdx * 16 == yPosition + 8.0)
    {
        //Block perfectly aligns with grid, higher = lower
        return yIdx - 1;
    }
    return yIdx;
}

- (void)gameUpdate
{
    [super gameUpdate];
    TTGNode* theNode = [self findNodeByIdentifier:@"TetrisPiece"];
    [theNode translateByX:0 Y: -self.timeSinceLastFrame * _currentDropSpeed];
    if(theNode.spritePosition.y < 0)
    {
        //Move to the top of the screen if block gets below floor
        [theNode moveToX:[self getCurrentXPosition] Y:320];
    }
    
    //Detect if the tetris piece should become fixed blocks
    int lowerYIdx = [self getLowerY];
    bool ifBecomeFixedBlock = NO;
    if(theNode.spritePosition.y < 8)
    {
        ifBecomeFixedBlock = YES;
    }
    
    for(int row = 0; row < 4; row++)
    {
        for(int col = 0; col < 4;col++)
        {
            if([self queryBlockArrayForPiece:_currentPiece inRotation:_currentRotation Row:row Col:col])
            {
                int curBlockY = lowerYIdx + row - 2;
                if(curBlockY < 0)
                {
                    ifBecomeFixedBlock = YES;
                }
            }
        }
    }
    
    if(!ifBecomeFixedBlock)
    {
        for(int row = 0; row < 4; row++)
        {
            for(int col = 0; col < 4;col++)
            {
                if([self queryBlockArrayForPiece:_currentPiece inRotation:_currentRotation Row:row Col:col])
                {
                    int curBlockX = _currentX + col - 2;
                    int curBlockY = lowerYIdx + row - 2;
                    
                    if(curBlockY >= 0 && curBlockY < 20)
                    {
                        if( tetrisArray[curBlockY][curBlockX] != NOBLOCK_ENUM)
                        {
                            ifBecomeFixedBlock = YES;
                        }
                    }
                }
            }
        }
    }
    
    bool isGameOver = NO;
    
    if(ifBecomeFixedBlock)
    {
        for(int row = 0; row < 4; row++)
        {
            for(int col = 0; col < 4;col++)
            {
                if([self queryBlockArrayForPiece:_currentPiece inRotation:_currentRotation Row:row Col:col])
                {
                    int curBlockX = _currentX + col - 2;
                    int curBlockY = lowerYIdx + row - 2;
                    if(curBlockY + 1 < 20)
                    {
                        tetrisArray[curBlockY + 1][curBlockX] = _currentPiece;
                    }
                    else
                    {
                        isGameOver = YES;
                    }
                }
                if(isGameOver)
                    break;
            }
            if(isGameOver)
                break;
        }
        
        if(!isGameOver)
        {
            //Reset drop speed when tetris piece is fixed in place.
            _currentDropSpeed = 40.0;
            //Randomly generate a tetris block
            _currentX = 4;
            _currentRotation = 0;
            _currentPiece = arc4random() % 7 + 1;
            //Reset the piece in the top
            [theNode moveToX:[self getCurrentXPosition] Y:320];
            [self updateCurrentPieceTexture];
        }
    }
    
    if(!isGameOver)
    {
        [self removeCompletedRows];
        for(int row= 0; row < 20; row++)
        {
            for(int col = 0; col < 10; col++)
            {
                tetrisArrayIBlockPtr[row][col].hide = YES;
                tetrisArrayJBlockPtr[row][col].hide = YES;
                tetrisArrayLBlockPtr[row][col].hide = YES;
                tetrisArrayOBlockPtr[row][col].hide = YES;
                tetrisArraySBlockPtr[row][col].hide = YES;
                tetrisArrayTBlockPtr[row][col].hide = YES;
                tetrisArrayZBlockPtr[row][col].hide = YES;
                
                if(tetrisArray[row][col] == IBLOCK_ENUM)
                {
                    tetrisArrayIBlockPtr[row][col].hide = NO;
                }
                else if(tetrisArray[row][col] == JBLOCK_ENUM)
                {
                    tetrisArrayJBlockPtr[row][col].hide = NO;
                }
                else if(tetrisArray[row][col] == LBLOCK_ENUM)
                {
                    tetrisArrayLBlockPtr[row][col].hide = NO;
                }
                else if(tetrisArray[row][col] == OBLOCK_ENUM)
                {
                    tetrisArrayOBlockPtr[row][col].hide = NO;
                }
                else if(tetrisArray[row][col] == SBLOCK_ENUM)
                {
                    tetrisArraySBlockPtr[row][col].hide = NO;
                }
                else if(tetrisArray[row][col] == TBLOCK_ENUM)
                {
                    tetrisArrayTBlockPtr[row][col].hide = NO;
                }
                else if(tetrisArray[row][col] == ZBLOCK_ENUM)
                {
                    tetrisArrayZBlockPtr[row][col].hide = NO;
                }
            }
        }
    }
    else
    {
        [self gameOver];
    }
}

- (bool)queryBlockArrayForPiece:(TetrisBlockName)pieceName inRotation:(int)rotation Row:(int)row Col:(int)col
{
    if(pieceName == OBLOCK_ENUM)
    {
        return OPiece[row][col];
    }
    else if(pieceName == IBLOCK_ENUM)
    {
        if(rotation == 0)
        {
            return IPiece1[row][col];
        }
        else
        {
            return IPiece2[row][col];
        }
    }
    else if(pieceName == SBLOCK_ENUM)
    {
        if(rotation == 0)
        {
            return SPiece1[row][col];
        }
        else
        {
            return SPiece2[row][col];
        }
    }
    else if(pieceName == ZBLOCK_ENUM)
    {
        if(rotation == 0)
        {
            return ZPiece1[row][col];
        }
        else
        {
            return ZPiece2[row][col];
        }
    }
    else if(pieceName == LBLOCK_ENUM)
    {
        if(rotation == 0)
        {
            return LPiece1[row][col];
        }
        else if(rotation == 1)
        {
            return LPiece2[row][col];
        }
        else if(rotation == 2)
        {
            return LPiece3[row][col];
        }
        else
        {
            return LPiece4[row][col];
        }
    }
    else if(pieceName == JBLOCK_ENUM)
    {
        if(rotation == 0)
        {
            return JPiece1[row][col];
        }
        else if(rotation == 1)
        {
            return JPiece2[row][col];
        }
        else if(rotation == 2)
        {
            return JPiece3[row][col];
        }
        else
        {
            return JPiece4[row][col];
        }
    }
    else if(pieceName == TBLOCK_ENUM)
    {
        if(rotation == 0)
        {
            return TPiece1[row][col];
        }
        else if(rotation == 1)
        {
            return TPiece2[row][col];
        }
        else if(rotation == 2)
        {
            return TPiece3[row][col];
        }
        else
        {
            return TPiece4[row][col];
        }
    }
    
    return NO;
}

- (float)getCurrentXPosition
{
    return 160 + _currentX * 16 + 8;
}

- (void)removeCompletedRows
{
    bool isContinued = NO;
    for(int row = 0; row < 20; row++)
    {
        int counter = 0;
        for(int col = 0; col < 10; col++)
        {
            if(tetrisArray[row][col] != NOBLOCK_ENUM)
            {
                counter++;
            }
        }
        if(counter == 10)
        {
            //Move all the blocks down one row
            for(int i = row + 1; i < 20; i++)
            {
                for(int col = 0; col < 10; col++)
                {
                    tetrisArray[i-1][col] = tetrisArray[i][col];
                }
            }
            isContinued = YES;
        }
    }
    
    if(isContinued)
    {
        [self removeCompletedRows];
    }
}

- (void)gameOver
{
    for(int row= 0; row < 20; row++)
    {
        for(int col = 0; col < 10; col++)
        {
            tetrisArray[row][col] = NOBLOCK_ENUM;
        }
    }
    
    TTGNode* theNode = [self findNodeByIdentifier:@"TetrisPiece"];
    _currentX = 4;
    [theNode moveToX:[self getCurrentXPosition] Y:320];
}

@end
