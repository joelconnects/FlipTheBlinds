[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![Swift 4.2](https://img.shields.io/badge/Swift-4.x-orange.svg?style=flat
)](https://developer.apple.com/swift/)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

# FlipTheBlinds

FlipTheBlinds is an animation transition that creates a venetian blinds domino effect.

## Features

 * Animation transition for use in presentations, navigation, and switching between tabs.
 * Modal presentations can be programmatic or implemented using segues.
 * Transition direction and speed is customizable.
 * Designed for portrait device orientation.
 * Swift 3.0

## Demo

[![Screen Capture](https://img.youtube.com/vi/Pt0VacKUiWA/0.jpg)](https://www.youtube.com/watch?v=Pt0VacKUiWA)

![Animated GIF](http://i.imgur.com/iGvfj49.gif)

## Requirements

 * iOS 8.0+
 * Xcode 10.0+

## Usage

### Installation

```
  pod "FlipTheBlinds"
```

### Modal Presentations

  * Assign the `transitioningDelegate` property of the view controller being presented to the presenting view controller.
  * Add an extension to the presenting view controller that includes methods for the `UIViewControllerTransitioningDelegate`.
  * Return instances of the `FTBAnimationController` animator object using `FTBAnimationController(displayType:direction:speed:)` for presenting and dismissing.

```swift

  // MARK: Programmatic option

  func presentAction() {

    let toViewController = ToViewController()
    toViewController.transitioningDelegate = self
    self.present(toViewController, animated: true, completion: nil)

  }

  // MARK: Segue option

  func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      if segue.identifier == "segue", let destinationViewController = segue.destination as? toViewController {

          destinationViewController.transitioningDelegate = self

      }

  }

  // MARK: Transitioning Delegate

  extension fromViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FTBAnimationController(displayType: .present, direction: .up, speed: .moderate)

    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return FTBAnimationController(displayType: .dismiss, direction: .down, speed: .moderate)

    }

  }
```

### Navigation

  * Assign the `delegate` property of the navigation controller to the root view controller.
  * Add an extension to the root view controller that includes the `UINavigationControllerDelegate` and necessary transitioning method.
  * Return instances of the `FTBAnimationController` animator object using `FTBAnimationController(displayType:direction:speed:)` for push and pop.

```swift

  // MARK: Push

  func pushAction() {

      let navStackViewController = NavStackViewController()
      self.navigationController?.delegate = self
      self.navigationController?.pushViewController(navStackViewController, animated: true)

  }

  // MARK: Navigation Controller Delegate

  extension NavRootViewController: UINavigationControllerDelegate {

   func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

       switch operation {
       case .pop:
           return FTBAnimationController(displayType: .pop, direction: .right, speed: .moderate)
       case .push:
           return FTBAnimationController(displayType: .push, direction: .left, speed: .moderate)
       default:
           return nil
       }

   }

  }
```

### Tab Bar

  * Assign the `delegate` property of the tab bar controller to one of the root view controllers of the tab bar controller.
  * Add an extension to a root view controller that includes the `UITabBarControllerDelegate` and necessary transitioning method.
  * Return an instance of the `FTBAnimationController` animator object using `FTBAnimationController(displayType:direction:speed:)`.

```swift

  // MARK: Delegate

  override func viewDidLoad() {
      super.viewDidLoad()

      self.tabBarController?.delegate = self

  }

  // MARK: Tab Bar Controller Delegate

  extension TabBarRootOneViewController: UITabBarControllerDelegate {

      func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

          return FTBAnimationController(displayType: .tabSelected, direction: .down, speed: .moderate)

      }

  }
```

## Known Issues

 * The performance of `UIGraphicsImageRenderer` during modal transitions is slower. Further optimization is needed.
 * Drawing/Rendering images in the animator object can be problematic for the simulator. Device testing is recommended.
 * `drawHierarchy(in:afterScreenUpdates:)` is used for modal presentations and may cause an inconspicuous flicker.   

## License

 * FlipTheBlinds is released under the MIT license. See LICENSE for details.
