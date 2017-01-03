//
//  TabBarViewController.swift
//  FlipTheBlinds
//
//  Created by Joel Bell on 1/3/17.
//  Copyright © 2017 Flatiron School. All rights reserved.
//

import UIKit

// MARK: Main

class TabBarController: FTBTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabs()
        
        self.delegate = self
        animationController.setFromTransition(direction: .up, speed: .moderate)
        animationController.setToTransition(direction: .right, speed: .moderate)
        
    }

}

// MARK: Configure Tabs

extension TabBarController {
    
    func configureTabs() {
        
        let rootOneVC = TabBarRootOneViewController()
        let rootTwoVC = TabBarRootTwoViewController()
        self.setViewControllers([rootOneVC, rootTwoVC], animated: true)
        if let tabBarItems = self.tabBar.items {
            
            tabBarItems[0].title = "ONE"
            tabBarItems[1].title = "TWO"
            
        }
        
    }
    
    
}
