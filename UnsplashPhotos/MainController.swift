//
//  MainController.swift
//  UnsplashPhotos
//
//  Created by Aleksandar Micevski on 9.10.23.
//

import UIKit

class MainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.selectedIndex = 2
        
        let homeTab = HomeController.factoryController()
        homeTab.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        
        let collectionsTab = MyCollectionsController.factoryController()
        collectionsTab.tabBarItem = UITabBarItem(title: "My Collections", image: UIImage(systemName: "rectangle.on.rectangle"), tag: 2)
        
        let likedTab = LikedController.factoryController()
        likedTab.tabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart"), tag: 3)
        
        let profileTab = ProfileController.factoryController()
        profileTab.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 4)
        
        self.viewControllers = [homeTab, collectionsTab, likedTab, profileTab]
    }
}
