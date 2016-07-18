# ZoomTransitioning

[![License](https://img.shields.io/:license-mit-blue.svg)](https://doge.mit-license.org)
[![Language](https://img.shields.io/badge/language-swift-orange.svg?style=flat)](https://developer.apple.com/swift)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/ZoomTransitioning.svg?style=flat)](http://cocoadocs.org/docsets/ZoomTransitioning/)

## Overview
`ZoomTransitioning` provides a custom transition with image zooming animation.
When you use this library with `UINavigationController`, you can pop view controller with edge swiping.

![demo](images/demo.gif)

## Example
Run the example project in the Example directory. You don't have to `pod install`.

## Usage
Refer to the example project for details.

### `import ZoomTransitioning`
### Adopt `ZoomTransitionSourceDelegate` to source view controller

```swift
extension ImageListViewController: ZoomTransitionSourceDelegate {

    func transitionSourceImageView() -> UIImageView {
        return selectedImageView
    }

    func transitionSourceImageViewFrame(forward forward: Bool) -> CGRect {
        return selectedImageView.convertRect(selectedImageView.bounds, toView: view)
    }

    func transitionSourceWillBegin() {
        selectedImageView.hidden = true
    }

    func transitionSourceDidEnd() {
        selectedImageView.hidden = false
    }

    func transitionSourceDidCancel() {
        selectedImageView.hidden = false
    }
}
```

### Adopt `ZoomTransitionDestinationDelegate` to destination view controller

```swift
extension ImageDetailViewController: ZoomTransitionDestinationDelegate {

    func transitionDestinationImageViewFrame(forward forward: Bool) -> CGRect {
        if forward {
            let x: CGFloat = 0.0
            let y = topLayoutGuide.length
            let width = view.frame.width
            let height = width * 2.0 / 3.0
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            return largeImageView.convertRect(largeImageView.bounds, toView: view)
        }
    }

    func transitionDestinationWillBegin() {
        largeImageView.hidden = true
    }

    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {
        largeImageView.hidden = false
        largeImageView.image = imageView.image
    }

    func transitionDestinationDidCancel() {
        largeImageView.hidden = false
    }
}
```

### set `delegate` property of `UINavigationController`

```swift
import ZoomTransitioning

class NavigationController: UINavigationController {

    private let zoomNavigationControllerDelegate = ZoomNavigationControllerDelegate()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        delegate = zoomNavigationControllerDelegate
    }
}
```

## Requirements
iOS 8.0 or higher

## Installation

### CocoaPods
ZoomTransitioning is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'ZoomTransitioning'
```

## Author
WorldDownTown, WorldDownTown@gmail.com

## License
ZoomTransitioning is available under the MIT license. See the LICENSE file for more info.

