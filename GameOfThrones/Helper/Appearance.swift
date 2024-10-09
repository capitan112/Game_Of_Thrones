//
//  CustomNavigationController.swift
//  GameOfThrones
//
//  Created by Oleksiy Chebotarov on 08/10/2024.
//

import Foundation
import UIKit

class Appearance {
    static func setup() {
        // Tab Bar Appearance
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = UIColor(named: "TabBarTintColor")
        UITabBar.appearance().backgroundColor = .black
        
        // Navigation Bar Appearance
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] // Set title text color to white
        UINavigationBar.appearance().backgroundColor = .clear
        
        // UITextField Appearance
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        UITextField.appearance().clearButtonMode = .whileEditing
    }
}
