//
//  AppDelegate.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Appearance.setup()
        window = UIWindow(frame: UIScreen.main.bounds)

        if CommandLine.arguments.contains("--uitesting") {
            window?.rootViewController = createTabBar(with: MockNetworkService())
        } else {
            window?.rootViewController = createTabBar()
        }

        window?.makeKeyAndVisible()

        return true
    }

    func createTabBar(with networkService: NetworkServiceProtocol = NetworkService()) -> UITabBarController {
        let tabBarController = UITabBarController()

        let booksVC = BooksViewController(viewModel: BooksViewModel(networkService: networkService))
        let booksNavController = UINavigationController(rootViewController: booksVC)
        booksNavController.tabBarItem = UITabBarItem(title: "Books",
                                                     image: UIImage(named: "tabbarBooks"),
                                                     selectedImage: UIImage(named: "tabbarBooksActive"))
        let housesVC = HousesViewController(viewModel: HousesViewModel(networkService: networkService))
        let housesNavController = UINavigationController(rootViewController: housesVC)
        housesNavController.tabBarItem = UITabBarItem(title: "Houses",
                                                      image: UIImage(named: "tabbarHouses"),
                                                      selectedImage: UIImage(named: "tabbarHousesActive"))

        let charactersVC = CharactersViewController(viewModel: CharactersViewModel(networkService: networkService))
        let charactersNavController = UINavigationController(rootViewController: charactersVC)
        charactersNavController.tabBarItem = UITabBarItem(title: "Characters",
                                                          image: UIImage(named: "tabbarCharacters"),
                                                          selectedImage: UIImage(named: "tabbarCharactersActive"))

        tabBarController.viewControllers = [booksNavController, housesNavController, charactersNavController]

        return tabBarController
    }
}
