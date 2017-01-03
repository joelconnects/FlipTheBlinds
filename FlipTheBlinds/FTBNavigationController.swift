//
//  FTBPresentingViewController.swift
//  FlipTheBlindsNonsense
//
//  Created by Joel Bell on 1/2/17.
//  Copyright © 2017 Flatiron School. All rights reserved.
//

import UIKit

// MARK: Main

class FTBNavigationController: UINavigationController {
    
    lazy var animationController = FTBAnimationController()
    
}

// MARK: Navigaton Controller Delegate

extension FTBNavigationController: UINavigationControllerDelegate {
    
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


