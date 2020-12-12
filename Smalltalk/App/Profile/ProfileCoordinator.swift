//
//  ProfileCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class ProfileCoordinator {

    // MARK: - Container
    private let container: Container

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let profileViewModel = container.resolve(ProfileViewModel.self, argument: container)!
        profileViewModel.coordinator = self
        let profileViewController = ProfileViewController()
        profileViewController.viewModel = profileViewModel
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 4)
        navigationController.viewControllers = [profileViewController]
    }

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
