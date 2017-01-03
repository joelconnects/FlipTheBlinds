//
//  BlindsPresentAnimationController.swift
//  FlipTheBlindsNonsense
//
//  Created by Joel Bell on 9/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

// MARK: Main Configuration

class FTBAnimationController: NSObject {

    typealias Settings = (direction: Direction, speed: Speed)
    
    fileprivate var fromSettings: Settings
    fileprivate var toSettings: Settings
    fileprivate var settings: Settings
    
    fileprivate var delayIntervals = [Int]()
    
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
    
    var displayType: DisplayType = .present {
        didSet {
            switch displayType {
            case .dismiss:
                settings = toSettings
            case .pop:
                settings = toSettings
            case .present:
                settings = fromSettings
            case .push:
                settings = fromSettings
            }
        }
    }

    enum DisplayType {
        case dismiss
        case pop
        case push
        case present
    }
    
    enum Direction {
        case down
        case left
        case right
        case up
    }
    
    enum Speed: Double {
        case fast = 0.6
        case moderate = 0.9
        case slow = 2.0
    }
    
    override init() {
        
        fromSettings = (.up, .moderate)
        toSettings = (.down, .moderate)
        settings = fromSettings
    }
    
    func setFromTransition(direction: Direction, speed: Speed) {
        fromSettings = (direction, speed)
    }
    
    func setToTransition(direction: Direction, speed: Speed) {
        toSettings = (direction, speed)
    }

}

// MARK: Transitioning Delegate

extension FTBAnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return settings.speed.rawValue
    
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
             else {return}
        
       var fromImage: UIImage
        
        switch displayType {
        case .present, .dismiss:
            fromImage = fromVC.view.drawImage()
        case .pop, .push:
            fromImage = fromVC.view.renderImage()
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)
        
        let backgroundView = UIView(frame: containerView.frame)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        containerView.addSubview(backgroundView)
    
        let duration = transitionDuration(using: transitionContext)
        let delay = duration * delayMultiplier
        let durationIntervals = 4.0
        let intervalDuration = (((Double(slices)-1) * delay) - duration) / -durationIntervals
        
        var toImage: UIImage
        
        switch displayType {
        case .present, .dismiss:
            toImage = toVC.view.drawImage()
        case .pop, .push:
            toImage = toVC.view.renderImage()
        }
    
        toVC.view.isHidden = true

        var fromImages = [UIImage]()
        var toImages = [UIImage]()
        
        switch settings.direction {
        case .up, .down:
            
            fromImages = fromImage.generateImage(slices: slices, type: .horizontal)
            toImages = toImage.generateImage(slices: slices, type: .horizontal)
            
            var yOrigin: CGFloat = 0
            for index in 0..<slices {
                
                delayIntervals.append(index)
                
                let sliceSize = CGSize(width: containerView.bounds.width, height: containerView.bounds.height/CGFloat(slices))
                let contentView = ContentView(frame: CGRect(x: 0, y: yOrigin, width: sliceSize.width, height: sliceSize.height))
                yOrigin += sliceSize.height
                
                contentView.fromView.image = fromImages[index]
                contentView.toView.image = UIImage(cgImage: toImages[index].cgImage!, scale: 1.0, orientation: .downMirrored)
                contentView.toView.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                backgroundView.addSubview(contentView)
                
            }
            
        case .left, .right:
            
            fromImages = fromImage.generateImage(slices: slices, type: .vertical)
            toImages = toImage.generateImage(slices: slices, type: .vertical)
            
            var xOrigin: CGFloat = 0
            for index in 0..<slices {
                
                delayIntervals.append(index)
                
                let sliceSize = CGSize(width: containerView.bounds.width/CGFloat(slices), height: containerView.bounds.height)
                let contentView = ContentView(frame: CGRect(x: xOrigin, y: 0, width: sliceSize.width, height: sliceSize.height))
                xOrigin += sliceSize.width
                
                contentView.fromView.image = fromImages[index]
                contentView.toView.image = UIImage(cgImage: toImages[index].cgImage!, scale: 1.0, orientation: .upMirrored)
                contentView.toView.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                backgroundView.addSubview(contentView)
                
            }
            
        }
        
        switch settings.direction {
        case .up, .left:
            
            for index in stride(from: (slices - 1), through: 0, by: -1) {
                
                let delayInterval = delayIntervals.removeFirst()
                let animationDelay = delay * Double(delayInterval)
                
                animate(contentView: backgroundView.subviews[index] as! ContentView, intervalDuration: intervalDuration, delay: animationDelay, completion: {
                    if index == 0 {
                        toVC.view.isHidden = false
                        backgroundView.removeFromSuperview()
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
                })
            }
            
        case .down, .right:
            
            for index in 0..<slices {
    
                let delayInterval = delayIntervals.removeFirst()
                let animationDelay = delay * Double(delayInterval)
    
                animate(contentView: backgroundView.subviews[index] as! ContentView, intervalDuration: intervalDuration, delay: animationDelay, completion: {
                    if index == (self.slices - 1) {
                        toVC.view.isHidden = false
                        backgroundView.removeFromSuperview()
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
                })
                
            }
        }
        
    }

}

// MARK: Animation
extension FTBAnimationController {
    
    fileprivate func animate(contentView: ContentView, intervalDuration duration: TimeInterval, delay: TimeInterval, completion: @escaping ()->()) {
        
        var transform: CATransform3D
        
        switch settings.direction {
        case .up:
            transform = CATransform3DMakeRotation(CGFloat(M_PI), 1, 0, 0)
            transform.m34 = -0.002
        case .down:
            transform = CATransform3DMakeRotation(CGFloat(M_PI), 1, 0, 0)
            transform.m34 = 0.002
        case .left:
            transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
            transform.m34 = 0.002
        case .right:
            transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0)
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
        fatalError("ERROR: ContentView does not use Interface Builder")
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
