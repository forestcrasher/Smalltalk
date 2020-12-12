//
//  FeedCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class FeedCoordinator {

    // MARK: - Container
    private let container: Container

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let feedViewModel = container.resolve(FeedViewModel.self, argument: container)!
        feedViewModel.coordinator = self
        let feedViewController = FeedViewController()
        feedViewController.viewModel = feedViewModel
        feedViewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "rectangle.stack.fill"), tag: 0)
        navigationController.viewControllers = [feedViewController]
    }

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }
}
