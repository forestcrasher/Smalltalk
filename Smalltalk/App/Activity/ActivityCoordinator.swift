//
//  ActivityCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class ActivityCoordinator {

    // MARK: - Container
    private let container: Container

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let activityViewModel = container.resolve(ActivityViewModel.self, argument: container)!
        activityViewModel.coordinator = self
        let activityViewController = ActivityViewController()
        activityViewController.viewModel = activityViewModel
        activityViewController.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "heart.fill"), tag: 3)
        navigationController.viewControllers = [activityViewController]
    }

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }
}
