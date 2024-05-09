<div style="text-align: center; width: 100%">
<img src="Documents/Sketch.png" width: 100% height: 100% alt="Sketch Logo">
</div>

![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg)
[![License](https://img.shields.io/cocoapods/l/Sketch.svg?style=flat)](http://cocoapods.org/pods/Sketch)
[![Language: Swift 5.0](https://img.shields.io/badge/swift-5.0-4BC51D.svg?style=flat)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org/pods/Sketch)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Sketch has basic functions for drawing from the beginning. Anyone can easily create drawing iOS Applications.

※ Below is the image of [app](https://itunes.apple.com/us/app/doodle-maker--paint%20and%20draw-/id1185784566?mt=8) actually made using Sketch.

![Sketch_animation1](https://raw.github.com/wiki/daihase/resource_manage/gifs/sketch-gif-image-1.gif)
![Sketch_animation2](https://raw.github.com/wiki/daihase/resource_manage/gifs/sketch-gif-image-2.gif)
![Sketch_animation3](https://raw.github.com/wiki/daihase/resource_manage/gifs/sketch-gif-image-3.gif)

## :memo: Features
- [x] Pen tool
- [x] Eraser tool
- [x] Stamp tool
- [x] Fill
- [x] Undo / Redo
- [x] Draw on Camera / Gallery image
- [x] Multiple colors can be set
- [x] Multiple width can be set
- [x] Multiple alpha can be set
- [x] Multiple tools (Line, Arrow, Rectangle, Ellipse, Star)
- [x] Multiple Pen Filters (Neon, Blur)

## :pencil2: Requirements
- Xcode 9.0+
- Swift 4.0+ (**Swift 5 is ready** :thumbsup:)

## :pencil2: Installation

#### Using [CocoaPods](https://cocoapods.org)

Sketch is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Sketch'
```

And run this command:
```ruby
$ pod install
 ```

#### Using [Carthage](https://github.com/Carthage/Carthage)

Add this to Cartfile:
```ruby
github "daihase/Sketch"
```

Then run this command:
```ruby
$ carthage update
```

Finally, add the framework:


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
let sketchView = SketchView(frame:
    CGRect(x: 0,
           y: 0,
           width: UIScreen.main.bounds.width,
           height: UIScreen.main.bounds.height
    )
)

self.view.addSubview(sketchView)
```

:ok_hand: Most of the functions are implemented in the Example Application. Please see that for details.

## :pencil2: Privacy

`Sketch` does not collect any data. A [privacy manifest file](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files) is [provided](Sketch/PrivacyInfo.xcprivacy).


## :pencil2: License

I am using Example Application icon from Freepik.  :point_right: [Designed by Freepik and distributed by Flaticon](https://www.freepik.com/)

Sketch is available under the MIT license. See the LICENSE file for more info.
