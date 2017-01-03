//
//  TabBarController.swift
//  FlipTheBlinds
//
//  Created by Joel Bell on 1/3/17.
//  Copyright © 2017 Flatiron School. All rights reserved.
//

import UIKit

// MARK: Main

class FTBTabBarController: UITabBarController {
    
    lazy var animationController = FTBAnimationController()
    
}

// MARK: Tab Bar Controller Delegate

extension FTBTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        animationController.displayType = .tabSelected
        return animationController
        
    }
    
}


