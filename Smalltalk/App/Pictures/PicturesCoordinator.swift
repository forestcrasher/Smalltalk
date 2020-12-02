//
//  PicturesCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class PicturesCoordinator {
    var navigationController: UINavigationController

    init() {
        let picturesViewController = PicturesViewController()
        picturesViewController.tabBarItem = UITabBarItem(title: "Pictures", image: UIImage(systemName: "photo.on.rectangle.fill"), tag: 1)
        navigationController = BaseNavigationController(rootViewController: picturesViewController)
    }
}
