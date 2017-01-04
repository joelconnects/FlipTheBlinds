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
        
    }

}

// MARK: Configure Tabs

extension TabBarController {
    
    func configureTabs() {
        
        let rootOneVC = TabBarRootOneViewController()
        let rootTwoVC = TabBarRootTwoViewController()
        let rootThreeVC = TabBarRootThreeViewController()
        self.setViewControllers([rootOneVC, rootTwoVC, rootThreeVC], animated: true)
        if let tabBarItems = self.tabBar.items {
            
            tabBarItems[0].title = "1"
            tabBarItems[1].title = "2"
            tabBarItems[2].title = "3"
            
        }
        
    }
    
    
}
