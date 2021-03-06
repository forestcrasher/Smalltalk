//
//  ProfileCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class ProfileCoordinator {

    // MARK: - Public
    let navigationController: UINavigationController = BaseNavigationController()

    // MARK: - Private
    private let container: Container

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    func start() {
        let profileViewModel = container.resolve(ProfileViewModel.self, argument: container)!
        profileViewModel.coordinator = self
        let profileViewController = ProfileViewController(viewModel: profileViewModel)
        profileViewController.tabBarItem = UITabBarItem(title: R.string.localizable.profileTitle(), image: UIImage.personFill, tag: 4)
        navigationController.viewControllers = [profileViewController]
    }

}
