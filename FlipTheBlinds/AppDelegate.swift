//
//  AppDelegate.swift
//  FlipTheBlinds
//
//  Created by Joel Bell on 1/2/17.
//  Copyright © 2017 Joel Bell. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController = AppController()
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        
        if let window = window {
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
        
        return true
    }

}

