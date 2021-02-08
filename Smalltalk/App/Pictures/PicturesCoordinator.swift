//
//  PicturesCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class PicturesCoordinator {

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
        let picturesViewModel = container.resolve(PicturesViewModel.self, argument: container)!
        picturesViewModel.coordinator = self
        let picturesViewController = PicturesViewController(viewModel: picturesViewModel)
        picturesViewController.tabBarItem = UITabBarItem(title: R.string.localizable.picturesTitle(), image: UIImage.photoOnRectangleFill, tag: 1)
        navigationController.viewControllers = [picturesViewController]
    }

}
