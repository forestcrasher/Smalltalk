//
//  ProfileCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class ProfileCoordinator {
    var navigationController: UINavigationController

    init() {
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
        navigationController = BaseNavigationController(rootViewController: profileViewController)
    }
}
