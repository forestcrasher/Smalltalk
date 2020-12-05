//
//  PicturesCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class PicturesCoordinator {

    // MARK: - Public
    var navigationController: UINavigationController = BaseNavigationController()

    func start() {
        let picturesViewController = PicturesViewController()
        picturesViewController.tabBarItem = UITabBarItem(title: "Pictures", image: UIImage(systemName: "photo.on.rectangle.fill"), tag: 1)
        navigationController.viewControllers = [picturesViewController]
    }

}
