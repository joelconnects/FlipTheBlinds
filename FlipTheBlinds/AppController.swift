//
//  AppController.swift
//  FlipTheBlinds
//
//  Created by Joel Bell on 1/2/17.
//  Copyright © 2017 Joel Bell. All rights reserved.
//

import UIKit

class AppController: UIViewController {
    
    var containerView: UIView!
    var menuView: UIView!
    var actingViewController: UIViewController!
    var demoType: DemoType = .modal
    
    var blurEffectView: UIVisualEffectView?
    
    var menuButton: UIImageView!
    var menuLayoutView: UIView!
    var menuLayoutConstraint: NSLayoutConstraint!
    
    var menuViewAppearanceConstraint: NSLayoutConstraint!
    
    enum DemoType: String {
        
        case modal = "Modal"
        case navigation = "Nav"
        case tab = "Tab"
        
        static let allValues = [modal.rawValue, navigation.rawValue, tab.rawValue]
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureContainerView()
        configureMenuView()
        configureMenuButton()
        
        actingViewController = generateViewController(forType: demoType)
        addInitialActing(viewController: actingViewController)
        
    }

}

// MARK: Set Up

extension AppController {

    fileprivate func configureContainerView() {
        
        containerView = UIView()
        containerView.frame = view.bounds
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(containerView)
        
    }
    
    fileprivate func configureMenuView() {
        
        menuLayoutView = UIView()
        menuLayoutView.backgroundColor = UIColor.clear
        
        view.addSubview(menuLayoutView)
        
        menuLayoutView.translatesAutoresizingMaskIntoConstraints = false
        menuLayoutView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        menuLayoutView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuLayoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        menuLayoutConstraint = menuLayoutView.widthAnchor.constraint(equalTo: view.widthAnchor)
        menuLayoutConstraint.isActive = true
        
        
        menuView = UIView()
        menuView.backgroundColor = UIColor.black
        menuView.alpha = 0.8
        
        view.addSubview(menuView)
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25).isActive = true
        menuView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        menuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: menuLayoutView.trailingAnchor).isActive = true
        
        let menuFillerView = UIView()
        menuFillerView.backgroundColor = UIColor.black
        menuView.alpha = 0.8
        
        view.addSubview(menuFillerView)
        
        menuFillerView.translatesAutoresizingMaskIntoConstraints = false
        menuFillerView.widthAnchor.constraint(equalTo: menuView.widthAnchor).isActive = true
        menuFillerView.heightAnchor.constraint(equalTo: menuView.heightAnchor).isActive = true
        menuFillerView.topAnchor.constraint(equalTo: menuView.topAnchor).isActive = true
        menuFillerView.leadingAnchor.constraint(equalTo: menuView.trailingAnchor).isActive = true
        
        let menuStackView = UIStackView()
        menuStackView.axis = .vertical
        menuStackView.alignment = .center
        menuStackView.spacing = 15
        menuStackView.distribution = .fillEqually
        
        menuView.addSubview(menuStackView)
        
        menuStackView.translatesAutoresizingMaskIntoConstraints = false
        menuStackView.centerXAnchor.constraint(equalTo: menuView.centerXAnchor).isActive = true
        menuStackView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor, constant: -60).isActive = true
        
        for title in DemoType.allValues {
            
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 0.2))
            button.backgroundColor = UIColor.clear
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            
            menuStackView.addArrangedSubview(button)
            
            button.widthAnchor.constraint(equalTo: menuView.widthAnchor, multiplier: 0.6).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1).isActive = true
            
        }

    }

    fileprivate func configureMenuButton() {
        
        menuButton = UIImageView()
        menuButton.image = #imageLiteral(resourceName: "menuButton")
        menuButton.alpha = 0.7
        menuButton.isUserInteractionEnabled = true
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(menuSwiped(_:)))
        swipe.direction = .left
        menuButton.addGestureRecognizer(swipe)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(menuSwiped(_:)))
        swipeRight.direction = .right
        menuButton.addGestureRecognizer(swipeRight)
        
        view.addSubview(menuButton)
        
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: menuView.leadingAnchor).isActive = true
        menuButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
}

// MARK: Actions

extension AppController {
    
    @objc func menuSwiped(_ sender: UISwipeGestureRecognizer) {
        
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowOffset = CGSize.zero
        menuView.layer.shadowRadius = 5
        menuView.layer.shadowPath = UIBezierPath(rect: menuView.bounds).cgPath
        
        var multiplier: CGFloat = 0
        var menuShadowOpacity: Float = 0
        var blurEffect: UIBlurEffect?
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.right:
            multiplier = 1
            menuShadowOpacity = 0
            blurEffect = nil
            
        case UISwipeGestureRecognizerDirection.left:
            multiplier = 0.75
            menuShadowOpacity = 1
            
            blurEffect = UIBlurEffect(style: .regular)
            blurEffectView = UIVisualEffectView()
            blurEffectView?.frame = actingViewController.view.bounds
            blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.insertSubview(blurEffectView!, belowSubview: menuView)
            
        default:
            break
        }
        
        self.menuView.layer.shadowOpacity = menuShadowOpacity
        
        self.menuLayoutConstraint.isActive = false
        self.menuLayoutConstraint = self.menuLayoutView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: multiplier)
        self.menuLayoutConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.blurEffectView?.effect = blurEffect
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
            
            self.view.layoutIfNeeded()
            
        }) { _ in
            
            if sender.direction == .right {
                self.blurEffectView?.removeFromSuperview()
                
            }
        }
        
    }
    
    @objc func menuButtonTapped(_ sender: UIButton) {
        
        guard let titleText = sender.titleLabel?.text else { fatalError() }
        
        switch titleText {
        case DemoType.modal.rawValue:
            demoType = .modal
        case DemoType.navigation.rawValue:
            demoType = .navigation
        case DemoType.tab.rawValue:
            demoType = .tab
        default:
            break
        }
        
        switchToViewController(withDemoType: demoType)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(menuSwiped(_:)))
        swipeRight.direction = .right
        menuSwiped(swipeRight)
        
    }
    
}

// MARK: View Controller Generation

extension AppController {
    
    fileprivate func generateViewController(forType type: DemoType) -> UIViewController {
        
        switch type {
        case .modal:
            return FromViewController()
        case .navigation:
            return UINavigationController(rootViewController: NavRootViewController())
        case .tab:
            return generateTabBarController()
        }
        
    }
    
    fileprivate func generateTabBarController() -> UITabBarController {
        
        let tabBarController = UITabBarController()
        let rootOneVC = TabBarRootOneViewController()
        let rootTwoVC = TabBarRootTwoViewController()
        let rootThreeVC = TabBarRootThreeViewController()
        tabBarController.setViewControllers([rootOneVC, rootTwoVC, rootThreeVC], animated: true)

        let customTabBarItemOne = UITabBarItem(title: "RED", image: #imageLiteral(resourceName: "redTab"), selectedImage: nil)
        let customTabBarItemTwo = UITabBarItem(title: "GREEN", image: #imageLiteral(resourceName: "greenTab"), selectedImage: nil)
        let customTabBarItemThree = UITabBarItem(title: "BLUE", image: #imageLiteral(resourceName: "blueTab"), selectedImage: nil)
        
        rootOneVC.tabBarItem = customTabBarItemOne
        rootTwoVC.tabBarItem = customTabBarItemTwo
        rootThreeVC.tabBarItem = customTabBarItemThree
        
        return tabBarController
    }
    
}

// MARK: View Controller Handling

extension AppController {
    
    fileprivate func addInitialActing(viewController: UIViewController) {
        
        self.addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
        
    }
    
    fileprivate func switchToViewController(withDemoType type: DemoType) {
        
        let exitingViewController = actingViewController
        exitingViewController?.willMove(toParentViewController: nil)
        
        actingViewController = generateViewController(forType: type)
        self.addChildViewController(actingViewController)
        
        containerView.addSubview(actingViewController.view)
        actingViewController.view.frame = containerView.bounds
        actingViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        actingViewController.view.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.actingViewController.view.alpha = 1
            exitingViewController?.view.alpha = 0
            
        }) { completed in
            exitingViewController?.view.removeFromSuperview()
            exitingViewController?.removeFromParentViewController()
            self.actingViewController.didMove(toParentViewController: self)
        }
        
    }
    
}







