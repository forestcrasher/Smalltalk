//
//  MessagesCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class MessagesCoordinator {
    var navigationController: UINavigationController

    init() {
        let messagesViewController = MessagesViewController()
        messagesViewController.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(systemName: "message.fill"), tag: 2)
        navigationController = BaseNavigationController(rootViewController: messagesViewController)
    }
}
