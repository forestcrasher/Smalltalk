//
//  FeedCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class FeedCoordinator {

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let feedViewModel = AppDelegate.container.resolve(FeedViewModel.self)!
        feedViewModel.coordinator = self
        let feedViewController = FeedViewController()
        feedViewController.viewModel = feedViewModel
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "rectangle.stack.fill"), tag: 0)
        navigationController.viewControllers = [feedViewController]
    }

}
