<div style="text-align: center; width: 100%">
<img src="Documents/Sketch.png" width: 100% height: 100% alt="Sketch Logo">
</div>

## Sketch
[![Build Status](https://travis-ci.org/daihase/Sketch.svg?branch=master)](https://travis-ci.org/daihase/Sketch)
![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg)
[![License](https://img.shields.io/cocoapods/l/Sketch.svg?style=flat)](http://cocoapods.org/pods/Sketch)
[![Language: Swift 4.0](https://img.shields.io/badge/swift-4.0-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org/pods/Sketch)

Sketch has the basic functions for drawing from the beginning. Anyone can easily create drawing iOS Applications.

![Sketch_animation1](https://raw.github.com/wiki/daihase/resource_manage/gifs/sketch-animation.gif)

## :memo: Features
- [x] Pen tool
- [x] Eraser tool
- [x] Stamp tool
- [x] Undo / Redo
- [x] Draw on Camera / Gallery image
- [x] Multiple colors can be set
- [x] Multiple width can be set
- [x] Multiple alpha can be set
- [x] Multiple tools (Line, Arrow, Rectangle, Ellipse, Star)
- [x] Multiple Pen Filters (Neon, Blur)

## :pencil2: Requirements
- Xcode 9.0+
- Swift 4.0+ (**Swift 4.2 is ready** :thumbsup:)

## :pencil2: Installation

#### Using [CocoaPods](https://cocoapods.org)

Sketch is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Sketch'
```

And run  `pod install`


## :pencil2: How to use

**Using IB/Storyboards:**

Only **3** steps needed to use `SketchView`

  **1.** Set UIView on Storyboard.

  **2.** Open Inspector and enter `SketchView` in the Class field of Custom Class.

  **3.** Then just connect `SketchView` to UIViewController as usual.

<img src="Documents/Storyboard.png" width="797" height="522" alt="Sketch Logo">

**Using code:**

  **1.** Import `Sketch` in proper place.
```swift
import Sketch
```

**2.** Create `SketchView`, and addSubview to the view you want to set.

```Swift
let sketchView = SketchView(frame: CGRect(
  x: 0,
  y: 0,
  width: UIScreen.main.bounds.width,
  height: UIScreen.main.bounds.height)
)

self.view.addSubview(sketchView)
```

:ok_hand: Most of the functions are implemented in the Example Application. Please see that for details.

## :pencil2: License

I am using Example Application icon from Freepik.  :point_right: [Designed by Freepik and distributed by Flaticon](https://www.freepik.com/)

Sketch is available under the MIT license. See the LICENSE file for more info.
