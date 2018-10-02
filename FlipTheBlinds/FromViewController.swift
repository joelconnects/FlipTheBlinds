//
//  FromViewController.swift
//  FlipTheBlinds
//
//  Created by Joel Bell on 1/2/17.
//  Copyright © 2017 Joel Bell. All rights reserved.
//

import UIKit

// MARK: Main

class FromViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configImageView()
        configButton()
        
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        let toViewController = ToViewController()
        
        // POD: Set transitioningDelegate
        toViewController.transitioningDelegate = self
        
        self.present(toViewController, animated: true, completion: nil)
        
    }

}

// MARK: Configure View

extension FromViewController {
    
    fileprivate func configImageView() {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "treeGlobeImage")
        
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
    fileprivate func configButton() {
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let buttonSize: CGFloat = 60
        let buttonYconstant: CGFloat = 50
        
        let buttonXorigin = (screenWidth / 2) - (buttonSize / 2)
        let buttonYorigin = screenHeight - buttonSize - buttonYconstant
        
        let button = UIButton(type: .custom)
        button.alpha = 0.7
        button.backgroundColor = UIColor.black
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.setTitle("GO", for: UIControl.State())
        button.frame = CGRect(x: buttonXorigin, y: buttonYorigin, width: buttonSize, height: buttonSize)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
}

// POD: Add Modal Extension

extension FromViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FTBAnimationController(displayType: .present, direction: .up, speed: .moderate)
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return FTBAnimationController(displayType: .dismiss, direction: .down, speed: .moderate)
        
    }
    
}



