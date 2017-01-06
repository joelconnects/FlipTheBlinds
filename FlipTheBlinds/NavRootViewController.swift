//
//  ViewController.swift
//  FlipTheBlindsNonsense
//
//  Created by Joel Bell on 9/4/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

// MARK: Main

class NavRootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configImageView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Go", style: .plain, target: self, action: #selector(goTapped))
        
    }
    
    func goTapped() {
        
        let navStackViewController = NavStackViewController()
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(navStackViewController, animated: true)
        
    }
    
}

// MARK: Configure View

extension NavRootViewController {
    
    fileprivate func configImageView() {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "noCoupleImage")
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
}

// POD: Navigtation Extension

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

