# Zen2D
A component-based iOS 2D game engine
### About
This project was started in 2013 April in an attempt to replace Unity3D and Cocos2D for iOS 2D game development.
### How to use
Simply clone the project and run the demos, which should scale well on all iPhone devices (demos were built for iPhone only)
# Basics
### 1.Scene management
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
### 2.ZNode
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

