//
//  FeedCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class FeedCoordinator {

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
        let feedViewModel = container.resolve(FeedViewModel.self, argument: container)!
        feedViewModel.coordinator = self
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        feedViewController.tabBarItem = UITabBarItem(title: R.string.localizable.feedTitle(), image: UIImage.rectangleStackFill, tag: 0)
        navigationController.viewControllers = [feedViewController]
    }

}
