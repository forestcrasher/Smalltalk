//
//  ActivityCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class ActivityCoordinator {

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let activityViewModel = AppDelegate.container.resolve(ActivityViewModel.self)!
        activityViewModel.coordinator = self
        let activityViewController = ActivityViewController()
        activityViewController.viewModel = activityViewModel
        activityViewController.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "heart.fill"), tag: 3)
        navigationController.viewControllers = [activityViewController]
    }

}
