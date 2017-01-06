# FlipTheBlinds

## Description

FlipTheBlinds is an animation transition that creates a venetian blinds domino effect.

## Features

 * Animation transition for use in presentations, navigation, and switching between tabs.
 * Modal presentations can be programmatic or implemented using segues.
 * Transition direction and speed can be manipulated.
 * Designed for portrait device orientation.

## Demo

[![Screen Capture](https://img.youtube.com/vi/Pt0VacKUiWA/0.jpg)](https://www.youtube.com/watch?v=Pt0VacKUiWA)

## Requirements

 * iOS 8.0+
 * Xcode 10.0+

## Usage

 * **Modal Presentations**
  * Assign the `transitioningDelegate` of the view controller being presented to the presenting view controller.
  * Add an extension to the presenting view controller that includes adherence and methods for the `UIViewControllerTransitioningDelegate`.
  * Return an instance of the `FTBAnimationController(displayType:direction:speed:)` animator object.

```swift

  // MARK: Programmatic option

  func action() {

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


## Known Issues

 * Drawing/Rendering images in the animator object is problematic for the simulator, especially iPhone 7/7P. Device testing is recommended.
 * `drawHierarchy(in:afterScreenUpdates:)` is used for modal presentations. Waiting for the screen to update may cause an inconspicuous flicker.   
