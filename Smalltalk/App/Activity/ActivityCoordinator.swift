//
//  ActivityCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class ActivityCoordinator {

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
        let activityViewModel = container.resolve(ActivityViewModel.self, argument: container)!
        activityViewModel.coordinator = self
        let activityViewController = ActivityViewController(viewModel: activityViewModel)
        activityViewController.tabBarItem = UITabBarItem(title: R.string.localizable.activityTitle(), image: UIImage.heartFill, tag: 3)
        navigationController.viewControllers = [activityViewController]
    }

}
