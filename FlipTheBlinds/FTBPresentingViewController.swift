//
//  FTBPresentingViewController.swift
//  FlipTheBlindsNonsense
//
//  Created by Joel Bell on 1/2/17.
//  Copyright © 2017 Flatiron School. All rights reserved.
//

import UIKit

// MARK: Main

class FTBPresentingViewController: UIViewController {
    
    let animationController = FTBAnimationController()
    
}

// MARK: Transitions

extension FTBPresentingViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        print("FTBAnimationController: present transition, return animation controller")
        
        animationController.displayType = .present
        return animationController
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        print("FTBAnimationController: dismiss transition, return animation controller")
        animationController.displayType = .dismiss
        return animationController
        
    }
    
    
}

// MARK: Navigaton Controller Delegate

extension FTBPresentingViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        print("FTBAnimationController: navigation controller delegate, return animation controller")
        
        switch operation {
        case .pop:
            animationController.displayType = .pop
        case .push:
            animationController.displayType = .push
        default:
            break
        }
        
        return animationController
        
    }
    
    
}
