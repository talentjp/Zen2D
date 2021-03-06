# Zen2D
A component-based iOS 2D game engine
### About
This project was started in 2013 April in an attempt to replace Unity3D and Cocos2D for iOS 2D game development.
### How to use
Simply clone the project and run the demos, which should scale well on all iPhone devices (demos were built for iPhone only)
# Basics
### 1. Scene management
```objective-c
[[ZSceneManager sharedManager] switchToScene:[[ZScene alloc] init]];
```
This singleton method sets the ZScene object as the active scene
There are 3 different scene classes :
#### ZScene
The basic scene class
#### ZCompositeScene
The container for other scene objects, for example:
```objective-c
[[ZCompositeScene alloc] initWithScenes:scene1, scene2, nil];
```
This will render 2 scenes at once
#### ZNavigationScene
If you are an XCode developer, this scene class acts like UINavigationController, which is essentially just a stack of scenes
```objective-c
ZNavigationScene* navScene = [[ZNavigationScene alloc] initWithWidth:1334 Height:750];
//To push a new scene
[navScene pushScene:scene];
//To pop an existing scene
ZNavigationScene* poppedScene = [navScene popScene];
```
#### Camera System
Every scene starts with a default camera object, which is 0 degree rotation and has a scale factor of 1.
You can translate, scale or rotate the camera like any ZNode, which will be covered in the following section.
To set the active camera, use the activeCamera property like so:
```objective-c
scene.activeCamera = camera;
```
### 2. ZNode
The ZNode class is the foundation for all objects that can be attached to a scene.
```objective-c
//To attach a node to a scene
[scene attachNode:node];
```
A ZNode can also contain other ZNodes, making it the parent node.
```objective-c
//To group nodes, attach them to the parent node
[parentNode attachNode:node1];
[parentNode attachNode:node2];
[parentNode attachNode:node3];
[parentNode attachNode:node4];
[parentNode attachNode:node5];
```
Any ZNode can be manipulated with many properties such as the opacity, scale, rotation, spritePosition...etc
```objective-c
[scene attachNode upperArm];
[upperArm attachNode:lowerArm];
//This is going to move the upperArm along with the lowerArm(childNode)
[upperArm moveToX:50 Y:50];
```
There are many derivatives of ZNode, for now let's just briefly summarize what they do:
#### ZSprite
Probably the most used ZNode class, for loading up any static images.
```objective-c
ZSprite* sprite = [[ZSprite alloc] initWithFile:@"img.png"];
```
Note that in order to specify the sequence in which the sprites are rendered, there is a depth property for ZSprite:
```objective-c
//This renders sprite 1 before sprite 2 (1 farther than 2)
sprite1.spriteDepth = -1;
sprite2.spriteDepth = -2;
```
#### ZText
A ZText object can be treated like a ZSprite once everything is set up
```objective-c
//A code snippet from my app
ZText* text = [[ZText alloc] initWithString:@"Some Text"];
[text roundTheCornersWithRadius:10];
[text setTextColor:[UIColor blackColor]];
[text setFont:[UIFont fontWithName:@"STYuanti-SC-Regular" size:200]];
[text setBackGroundColor:[UIColor colorWithRed:219.0/255.0 green:233.0/255.0 blue:246.0/255.0 alpha:1.0]];
[text moveToX:50  Y:50];
```
#### ZCamera
As mentioned in the earlier section a scene can specify a camera node to zoom in/out, pan, or rotate the camera
#### ZButton
A ZButton is a ZSprite that can be pressed, if there is a subscriber it will be notified of such events
```objective-c
//A code snippet from my app
ZButton* playButton = [[ZButton alloc] initWithFile:@"PlayButton.png"];
playButton.spritePosition = CGPointMake(512, 300);
[playButton subscribeWithObject:self AndSelector:@selector(playButtonPressed:)];
[self attachNode:playButton];
playButton.scale = CGSizeMake(0.6,0.6);
```
#### ZRectangle
As the name implies this class is used to draw any rectangles or lines
```objective-c
//In the demo
ZRectangle* colorRect = [[ZRectangle alloc] init];
colorRect.spriteSize = CGSizeMake(2000, 20);
colorRect.opacity = 0.5;
colorRect.solidColor = [UIColor purpleColor];
```
#### ZSpriteAnimation
A sprite animation is a series of sprites played in a particular sequence. In Zen2D even though one can still load individual sprites from different image files, the use of a sprite sheet is highly recommended.
```objective-c
[[ZTextureManager sharedManager] loadJSONSpriteSheet:@"megaman3d.json"];
```
This helper method parses JSON metadata and loads the sprite images into memory. The JSON takes the format:
```json
{"frames": [

{
	"filename": "Megaman00.gif",
	"frame": {"x":2,"y":2,"w":320,"h":240},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":320,"h":240},
	"sourceSize": {"w":320,"h":240}
},
{
	"filename": "Megaman01.gif",
	"frame": {"x":324,"y":2,"w":320,"h":240},
	"rotated": false,
	"trimmed": false,
	"spriteSourceSize": {"x":0,"y":0,"w":320,"h":240},
	"sourceSize": {"w":320,"h":240}
}],
"meta": {
	"app": "http://www.codeandweb.com/texturepacker ",
	"version": "1.0",
	"image": "megaman3d.png",
	"format": "RGBA8888",
	"size": {"w":2048,"h":2048},
	"scale": "1",
	"smartupdate": "$TexturePacker:SmartUpdate:05a6532bbb60b81a50517affd3cb927b:1/1$"
}}
```
However it's also recommended that one uses [TexturePacker](https://www.codeandweb.com/texturepacker) for the spritesheet generation (image + json), while there is no official tool yet.
After loading the spritesheet successfully into memory, one can start composing the animations.
```objective-c
ZSpriteAnimation* megaman = [[ZSpriteAnimation alloc] init];
NSMutableArray* arrayMegaman = [NSMutableArray array];
for(int i = 0; i <= 10;i++)
{
  [arrayMegaman addObject:[NSString stringWithFormat:@"Megaman%02d.gif",i]];
}
[megaman loadSpritesFromArrayOfFiles:arrayMegaman];
```
And to define the animations.
```objective-c
//Use all the sprites
[megaman defineAnimationNamed:@"megaman_FULL" OfDuration:1.5 AsSpriteIndices:0,1,2,3,4,5,6,7,8,9,10,nil];
```
To play a defined animation.
```objective-c
[megaman playAnimation:@"megaman_FULL" Looped:YES];
```
#### ZVirtualStick
An experimental virtual joystick class (will be more customizable in the future), to process the events, override the 4 existing methods.
```objective-c
- (void) buttonAPressed;
- (void) leftAnalogDown;
- (void) leftAnalogUp;
- (void) leftAnalogMoved;
```
### 3. ZAnimator
When we know beforehand how a ZNode object is animated over time we can apply ZAnimators to it.
#### ZMoveTo
This moves the node over 2 secs from (-100, 0) to (0,0)
```objective-c
node.spritePosition = CGPointMake(-100, 0);
[node addAnimator:[ZMoveTo moveToX:0 Y:0 During:2]];
```
#### ZScale
This scales the node over 2 secs from (1.0, 1.0) ratio to (2.0, 1.0) ratio (horizontal stretch)
```objective-c
[node addAnimator:[ZScale scaleToWidth:2.0 Height:1.0 During:2.0]];
```
#### ZRotate
This rotates the node over 2 secs 90 degress counter-clockwise
```objective-c
[node addAnimator:[ZRotate rotateBy:90 During:2]];
```
#### ZFade
This fades the node out over 2 secs from starting opacity to 0 opacity
```objective-c
[node addAnimator:[ZFade fadeOutDuring:2]]
```
This fades the node out over 2 secs from starting opacity to 1.0 opacity
```objective-c
[node addAnimator:[ZFadeIn fadeOutDuring:2]]
```
#### ZBlink
This makes the node twinkle over 4 secs with 1 secs cycle time (zero -> full -> zero opacity)
```objective-c
[node addAnimator:[ZBlink blinkDuring:4 WithCycle:1]];
```
#### ZBatch
Batch executes all animators at the same time
```objective-c
//From demo code
ZBatch* leftArmSequence = [ZBatch executeAnimators:[ZRotate rotateBy:-30 During:2], [ZTrigger triggerAnimator:[ZRotate rotateBy:30 During:2] After:2], nil];
[girlLeftArm addAnimator:leftArmSequence];
```
#### ZSequencer
Similar to ZBatch, but runs animations in turn.
```objective-c
//animator2 doesn't start running until animator1 finishes
[ZSequencer executeInSequence:animator1, animator2, nil;]
```
#### ZTrigger
This triggers the ZShake animator after 2 secs 
```objective-c
ZTrigger* trigger = [ZTrigger triggerAnimator:[ZShake shakeWithinDistance:30 During:1] After:2];
```
#### ZDestructor
A specialized animator that kills the node, can be used with trigger(timed death) or other schedulers.
```objective-c
//from my app
[red addAnimator:[TTGTrigger triggerAnimator:[TTGDestructor killSelf] After:COUNTDOWN_INTERVAL]];
```
#### ZPlaySound
Sound playback animator that can be scheduled.

### 4. Components
By attaching a component to the node, it gives the node a new capability.
#### ZTouchComponent
This gives the node ability to receive touch events
```objective-c
- (id)init
{
    if((self = [super init]))
    {
        //Component based design
        _touchComp = [[ZTouchComponent alloc] init];
        [self addComponent: _touchComp];
        //If absorb touch is on nothing behind it will receive any touch event
        _touchComp.isAbsorbTouch = NO;
    }
    return self;
}
```
All touch events should be processed inside the game loop, which makes it a lot more usable than Apple's stock asynchronous API (touchBegan and the likes)
```objective-c
//From the demo
- (void)gameUpdate
{
    if([_touchComp getLatestTouchEventAtIndex:0] == TOUCH_EVENT_DOWN)
    {
        ZNode* nodeToCopy = [self.parentScene findNodeByIdentifier:@"ROCK"];
        ZNode* newNode = [nodeToCopy copy];
        CGPoint newLocation = [_touchComp getLatestLocationAtIndex:0];
        [newNode moveToX:newLocation.x Y:newLocation.y];
        [newNode resetComponents];
        [self.parentScene attachNode:newNode];
    }
}
```
The above code querys the touch event at index 0 (MAX 19). In total, there are 5 types of touch events:
##### TOUCH_EVENT_NONE - Nothing happened at this index
##### TOUCH_EVENT_DOWN - Finger laid 
##### TOUCH_EVENT_MOVE - Finger dragged
##### TOUCH_EVENT_UP - Finger lifted
##### TOUCH_EVENT_DOWN_UP - User did a very quick tap on the display
#### ZSoundComponent
A node can also contain a sound component, currently only wav file is supported, which will be converted to caf on compilation.
```objective-c
- (id)init
{
    if((self = [super init]))
    {
        //Component based design
        _soundComp = [[ZSoundComponent alloc] init];
        [_soundComp loadFile:@"laser.wav"];
        [self addComponent: _soundComp];
    }
    return self;
}
```
To play:
```objective-c
[_soundComp play];
```
#### ZRigidbodyComponent
There are different ways to infer the shape data, first by using a plist, which has all the vertices.
```objective-c
ZSprite* rock = [[ZSprite alloc] initWithFile:@"rock.png"];
ZRigidbodyComponent* comp = [[ZRigidbodyComponent alloc] init];
[rock addComponent:comp];
[comp loadFixtureDataFromFile:@"rock.plist"];
```
Or let the the spriteSize imply the dimensions
```objective-c
ZRectangle* colorRect = [[ZRectangle alloc] init];
colorRect.spriteSize = CGSizeMake(2000, 20);
comp = [[ZRigidbodyComponent alloc] init];
[colorRect addComponent:comp];
[comp setupAsBoxWithInferredDimensions];
//Immovable body
[comp setAsStaticBody];   
```
There is also **setupAsCircleWithInferredRadius**
