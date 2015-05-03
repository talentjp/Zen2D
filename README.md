# Zen2D
A component-based iOS 2D game engine
### About
This project was started in 2013 April in an attempt to replace Unity3D and Cocos2D for iOS 2D game development.
### How to use
Simply clone the project and run the demos, which should scale well on all iPhone devices (demos were built for iPhone only)
# Learning from the demos
### 1.Scene management
```objective-c
[[ZSceneManager sharedManager] switchToScene:[[SceneSelectScene alloc] init]];
```
This singleton method sets the SceneSelectScene as the active scene
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




