//
//  MessagesCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class MessagesCoordinator {

    // MARK: - Container
    private let container: Container

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let messagesViewModel = container.resolve(MessagesViewModel.self, argument: container)!
        messagesViewModel.coordinator = self
        let messagesViewController = MessagesViewController()
        messagesViewController.viewModel = messagesViewModel
        messagesViewController.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(systemName: "message.fill"), tag: 2)
        navigationController.viewControllers = [messagesViewController]
    }

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
