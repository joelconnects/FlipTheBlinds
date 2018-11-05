//
//  IBTabBarRootOneViewController.swift
//  FlipTheBlinds
//
//  Created by Joel Bell on 1/2/17.
//  Copyright © 2017 Joel Bell. All rights reserved.
//

import UIKit

// MARK: Main

class IBTabBarRootOneViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configImageView()
        
        // POD: Set UITabBarController Delegate
        self.tabBarController?.delegate = self
    }
    
}

// MARK: Configure View

extension IBTabBarRootOneViewController {
    
    private func configImageView() {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "redImage")
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
}

// POD: Add Tab Extension

extension IBTabBarRootOneViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FTBAnimationController(displayType: .tabSelected, direction: .down, speed: .moderate)
        
    }
    
}

