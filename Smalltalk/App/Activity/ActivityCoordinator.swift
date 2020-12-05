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
        let activityViewController = ActivityViewController()
        activityViewController.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "heart.fill"), tag: 3)
        navigationController.viewControllers = [activityViewController]
    }

}
