//
//  ActivityCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class ActivityCoordinator {
    var navigationController: UINavigationController

    init() {
        let activityViewController = ActivityViewController()
        activityViewController.tabBarItem = UITabBarItem(title: "Activity", image: UIImage(systemName: "heart.fill"), tag: 3)
        navigationController = BaseNavigationController(rootViewController: activityViewController)
    }
}
