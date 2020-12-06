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
        let picturesViewModel = AppDelegate.container.resolve(PicturesViewModel.self)!
        picturesViewModel.coordinator = self
        let picturesViewController = PicturesViewController()
        picturesViewController.viewModel = picturesViewModel
        picturesViewController.tabBarItem = UITabBarItem(title: "Pictures", image: UIImage(systemName: "photo.on.rectangle.fill"), tag: 1)
        navigationController.viewControllers = [picturesViewController]
    }

}
