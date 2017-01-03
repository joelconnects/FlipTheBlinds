//
//  ViewController.swift
//  FlipTheBlindsNonsense
//
//  Created by Joel Bell on 9/4/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

// MARK: Main

class TabBarRootTwoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configImageView()
        
    }
}

// MARK: Configure View

extension TabBarRootTwoViewController {
    
    fileprivate func configImageView() {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "dracula")
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
}
