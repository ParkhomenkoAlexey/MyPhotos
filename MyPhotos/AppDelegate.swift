//
//  AppDelegate.swift
//  MyPhotos
//
//  Created by Алексей Пархоменко on 30/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainTabBarController = MainTabBarController()
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = mainTabBarController
        return true
    }
}

