//
//  AppDelegate.swift
//  FlipTheBlinds
//
//  Created by Joel Bell on 1/2/17.
//  Copyright © 2017 Flatiron School. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // DEMO: Modal Transition
        
        let rootViewController = FromViewController()
        rootViewController.animationController.setFromTransition(direction: .up, speed: .moderate)
        rootViewController.animationController.setToTransition(direction: .down, speed: .moderate)
        
        
        // DEMO: Navigation Transition
        
//        let rootViewController = FTBNavigationController(rootViewController: NavRootViewController())
//        rootViewController.delegate = rootViewController
//        rootViewController.animationController.setPushTransition(direction: .left, speed: .moderate)
//        rootViewController.animationController.setPopTransition(direction: .right, speed: .moderate)
        
        
        // DEMO: Tab Bar Transition
        
//        let rootViewController = TabBarController()
//        rootViewController.delegate = rootViewController
//        rootViewController.animationController.setFromTransition(direction: .up, speed: .moderate)
//        rootViewController.animationController.setToTransition(direction: .right, speed: .moderate)
        
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        
        if let window = window {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
        
        return true
    }

}

