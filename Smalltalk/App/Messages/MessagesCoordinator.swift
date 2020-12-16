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
        let messagesViewController = MessagesViewController(viewModel: messagesViewModel)
        messagesViewController.tabBarItem = UITabBarItem(title: R.string.localizable.messagesTitle(), image: UIImage.messageFill, tag: 2)
        navigationController.viewControllers = [messagesViewController]
    }

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
