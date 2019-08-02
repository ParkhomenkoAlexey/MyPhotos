//
//  MainTabBarController.swift
//  Apple Music Swiftbook
//
//  Created by Алексей Пархоменко on 17/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
//        UINavigationBar.appearance().prefersLargeTitles = true
        
        tabBar.tintColor = #colorLiteral(red: 0.008419650607, green: 0.8583433032, blue: 0.6806535125, alpha: 1)
        viewControllers = [
            generateNavigationController(with: PhotosCollectionViewController(collectionViewLayout: WaterfallLayout()), title: "Photos", image: #imageLiteral(resourceName: "Regular-M")),
            generateNavigationController(with: LikesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Favourites", image: #imageLiteral(resourceName: "heart"))
        ]
    }
    
    func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
//        navController.navigationBar.prefersLargeTitles = true
//        rootViewController.navigationItem.title = title
        navController.navigationBar.shadowImage = UIImage()
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}

