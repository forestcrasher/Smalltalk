//
//  FeedCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class FeedCoordinator {
    var navigationController: UINavigationController

    init() {
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "doc.fill"), tag: 0)
        navigationController = BaseNavigationController(rootViewController: feedViewController)
    }
}
