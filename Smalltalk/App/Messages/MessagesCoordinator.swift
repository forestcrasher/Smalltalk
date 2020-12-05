//
//  MessagesCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class MessagesCoordinator {

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let messagesViewController = MessagesViewController()
        messagesViewController.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(systemName: "message.fill"), tag: 2)
        navigationController.viewControllers = [messagesViewController]
    }

}
