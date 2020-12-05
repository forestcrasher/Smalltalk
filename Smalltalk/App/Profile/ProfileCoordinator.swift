//
//  ProfileCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class ProfileCoordinator {

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 4)
        navigationController.viewControllers = [profileViewController]
    }

}
