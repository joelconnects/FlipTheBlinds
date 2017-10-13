//
//  FTBAnimationController.swift
//  FlipTheBlinds
//
//  Created by Joel Bell on 1/2/17.
//  Copyright © 2017 Joel Bell. All rights reserved.
//

import UIKit

// MARK: Main

public class FTBAnimationController: NSObject {
    
    fileprivate let displayType: DisplayType
    fileprivate let settings: (direction: Direction, speed: Speed)
    fileprivate let sliceType: FTBSliceType
    
    fileprivate var slices: Int {
        switch settings.direction {
        case .up, .down:
            return 8
        case .left, .right:
            return 6
        }
    }
    
    fileprivate var delayMultiplier: Double {
        switch settings.direction {
        case .up, .down:
            return 0.05
        case .left, .right:
            return 0.08
        }
    }
    
    fileprivate var delay: Double {
        return settings.speed.rawValue * delayMultiplier
    }
    
    fileprivate var intervalDuration: Double {
        let durationIntervals = 4.0
        return (((Double(slices)-1) * delay) - settings.speed.rawValue) / -durationIntervals
    }

    public init(displayType: DisplayType, direction: Direction, speed: Speed) {
        
        self.displayType = displayType
        self.settings = (direction, speed)
        switch direction {
        case .up, .down:
            self.sliceType = .horizontal
        case .left, .right:
            self.sliceType = .vertical
        }
        
    }
    
}

// MARK: Transition Settings

extension FTBAnimationController {
    
    public enum DisplayType {
        case dismiss
        case pop
        case push
        case present
        case tabSelected
    }
    
    public enum Direction {
        case down
        case left
        case right
        case up
    }
    
    public enum Speed: Double {
        case fast = 0.6
        case moderate = 0.9
        case slow = 2.0
    }
    
}

// MARK: Transitioning Delegate

extension FTBAnimationController: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return settings.speed.rawValue
        
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {return}
        
        let containerView = transitionContext.containerView
        let animationView = generateAnimationView(forContainerView: containerView)
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(animationView)
        
        let fromImages = generateImage(ofView: fromVC.view).generateImage(slices: slices, type: sliceType)
        let toImages = generateImage(ofView: toVC.view).generateImage(slices: slices, type: sliceType)
        
        toVC.view.isHidden = true
        
        addContentViews(toAnimationView: animationView, fromImages: fromImages, toImages: toImages)
        
        animate(animationView: animationView) { 
            
            toVC.view.isHidden = false
            animationView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        }
        
    }
    
}

// MARK: Transition Formation

extension FTBAnimationController {
    
    fileprivate func generateImage(ofView view: UIView) -> UIImage {
        
        var image = UIImage()
        switch displayType {
        case .present, .dismiss:
            image = view.drawImage()
        case .pop, .push, .tabSelected:
            image = view.renderImage()
        }
        return image
        
    }
    
    fileprivate func generateAnimationView(forContainerView view: UIView) -> UIView {
        
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        return backgroundView
    }
    
    fileprivate func addContentViews(toAnimationView view: UIView, fromImages: [UIImage], toImages: [UIImage]) {
        
        var size: CGSize
        var point: CGPoint
        var orientation: UIImageOrientation
        
        for index in 0..<slices {
            
            switch settings.direction {
            case .up, .down:
                size = CGSize(width: view.bounds.width, height: view.bounds.height/CGFloat(slices))
                point = CGPoint(x: 0, y: CGFloat(index)*size.height)
                orientation = .downMirrored
            case .left, .right:
                size = CGSize(width: view.bounds.width/CGFloat(slices), height: view.bounds.height)
                point = CGPoint(x: CGFloat(index)*size.width, y: 0)
                orientation = .upMirrored
            }
            
            let contentView = ContentView(frame: CGRect(x: point.x, y: point.y, width: size.width, height: size.height))
            contentView.fromView.image = fromImages[index]
            contentView.toView.image = UIImage(cgImage: toImages[index].cgImage!, scale: 1.0, orientation: orientation)
            contentView.toView.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
            view.addSubview(contentView)
            
        }
        
    }
    
}

// MARK: Animation

extension FTBAnimationController {
    
    fileprivate func animate(animationView: UIView, completion: @escaping ()->()) {
        
        var delayIntervals = [Int](0..<slices)
        var intervals: [Int]
        
        switch settings.direction {
        case .up, .left:
            intervals = [Int]((0..<slices).reversed())
        case .down, .right:
            intervals = [Int](0..<slices)
        }
        
        for index in intervals {
            
            let delayInterval = delayIntervals.removeFirst()
            let animationDelay = delay * Double(delayInterval)
            let isLastInterval: Bool = index == intervals.last!
            
            animate(contentView: animationView.subviews[index] as! ContentView, intervalDuration: intervalDuration, delay: animationDelay, completion: {
                if isLastInterval{
                    completion()
                }
            })
        }
        
    }
    
    fileprivate func animate(contentView: ContentView, intervalDuration duration: TimeInterval, delay: TimeInterval, completion: @escaping ()->()) {
        
        var transform: CATransform3D
        
        switch settings.direction {
        case .up:
            transform = CATransform3DMakeRotation(.pi, 1, 0, 0)
            transform.m34 = -0.002
        case .down:
            transform = CATransform3DMakeRotation(.pi, 1, 0, 0)
            transform.m34 = 0.002
        case .left:
            transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            transform.m34 = 0.002
        case .right:
            transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
            transform.m34 = -0.002
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            completion()
        }
        
        var currentTime = contentView.layer.convertTime(CACurrentMediaTime(), from: nil)
        currentTime += delay
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            
            contentView.fromView.layer.opacity = 0
            contentView.toView.layer.opacity = 1
            
        }
        
        let fadeFromView = CABasicAnimation(keyPath: "opacity")
        fadeFromView.toValue = 0.9
        fadeFromView.duration = duration
        fadeFromView.beginTime = currentTime
        fadeFromView.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        fadeFromView.fillMode = kCAFillModeForwards
        fadeFromView.isRemovedOnCompletion = false
        contentView.fromShadowView.layer.add(fadeFromView, forKey: nil)
        
        CATransaction.commit()
        
        let rotateFromView = CABasicAnimation(keyPath: "transform")
        contentView.fromView.layer.zPosition = 100
        rotateFromView.toValue = NSValue(caTransform3D: transform)
        rotateFromView.duration = duration*2
        rotateFromView.beginTime = currentTime
        contentView.fromView.layer.add(rotateFromView, forKey: nil)
        
        let rotateToView = CABasicAnimation(keyPath: "transform")
        contentView.toView.layer.zPosition = 100
        rotateToView.toValue = NSValue(caTransform3D: transform)
        rotateToView.duration = duration*2
        rotateToView.beginTime = currentTime
        rotateToView.fillMode = kCAFillModeForwards
        rotateToView.isRemovedOnCompletion = false
        contentView.toView.layer.add(rotateToView, forKey: nil)
        
        let fadeToView = CABasicAnimation(keyPath: "opacity")
        fadeToView.toValue = 0.0
        fadeToView.duration = duration
        fadeToView.beginTime = currentTime + duration
        fadeToView.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        fadeToView.fillMode = kCAFillModeForwards
        fadeToView.isRemovedOnCompletion = false
        contentView.toShadowView.layer.add(fadeToView, forKey: nil)
        
        let scaleFromView = CABasicAnimation(keyPath: "transform.scale")
        scaleFromView.fromValue = 1.0
        scaleFromView.toValue = 0.95
        scaleFromView.duration = duration
        scaleFromView.beginTime = currentTime
        contentView.fromView.layer.add(scaleFromView, forKey: nil)
        
        let scaleToView = CABasicAnimation(keyPath: "transform.scale")
        scaleToView.fromValue = 0.93
        scaleToView.toValue = 1.0
        scaleToView.duration = duration
        scaleToView.beginTime = currentTime + duration
        scaleToView.fillMode = kCAFillModeForwards
        scaleToView.isRemovedOnCompletion = false
        contentView.toView.layer.add(scaleToView, forKey: nil)
        
        let scaleUpToView = CABasicAnimation(keyPath: "transform.scale")
        scaleUpToView.fromValue = 1.0
        scaleUpToView.toValue = 1.02
        scaleUpToView.duration = duration
        scaleUpToView.beginTime = currentTime + duration*2
        scaleUpToView.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        scaleUpToView.fillMode = kCAFillModeForwards
        scaleUpToView.isRemovedOnCompletion = false
        contentView.toView.layer.add(scaleUpToView, forKey: nil)
        
        let scaleDownToView = CABasicAnimation(keyPath: "transform.scale")
        scaleDownToView.fromValue = 1.02
        scaleDownToView.toValue = 1.0
        scaleDownToView.duration = duration
        scaleDownToView.beginTime = currentTime + duration*3
        scaleDownToView.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        scaleDownToView.fillMode = kCAFillModeForwards
        scaleDownToView.isRemovedOnCompletion = false
        contentView.toView.layer.add(scaleDownToView, forKey: nil)
        
        CATransaction.commit()
        
    }
    
}

// MARK: Animation Content View

fileprivate final class ContentView: UIView {
    
    var fromView: UIImageView!
    var toView: UIImageView!
    var fromShadowView: UIView!
    var toShadowView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        
        fromView = UIImageView(frame: self.bounds)
        toView = UIImageView(frame: self.bounds)
        toView.layer.opacity = 0
        
        fromShadowView = UIView(frame: self.bounds)
        toShadowView = UIView(frame: self.bounds)
        
        fromShadowView.backgroundColor = UIColor.black
        toShadowView.backgroundColor = UIColor.black
        fromShadowView.layer.opacity = 0
        
        fromView.addSubview(fromShadowView)
        toView.addSubview(toShadowView)
        
        self.addSubview(toView)
        self.addSubview(fromView)
        
    }
    
}
