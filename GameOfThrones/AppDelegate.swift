//
//  AppDelegate.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Appearance.setup()
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = UITabBarController()
        
        let housesVC = HousesViewController()
        let housesNavController = UINavigationController(rootViewController: housesVC)
        housesNavController.tabBarItem = UITabBarItem(title: "Houses",
                                                               image: UIImage(named: "tabbarHouses"),
                                                               selectedImage: UIImage(named: "tabbarHousesActive"))
                
        
        let booksVC = BooksViewController()
        let booksNavController = UINavigationController(rootViewController: booksVC)
        booksNavController.tabBarItem = UITabBarItem(title: "Books",
                                                            image: UIImage(named: "tabbarBooks"),
                                                            selectedImage: UIImage(named: "tabbarBooksActive"))
        

        tabBarController.viewControllers = [housesNavController, booksNavController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}
