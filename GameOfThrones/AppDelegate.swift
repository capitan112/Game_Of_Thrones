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
                
        
        let anotherVC = UIViewController()
        let anotherNavController = UINavigationController(rootViewController: anotherVC)
        anotherNavController.tabBarItem = UITabBarItem(title: "More", image: UIImage(systemName: "ellipsis"), tag: 1)
        

        tabBarController.viewControllers = [housesNavController, anotherNavController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}
