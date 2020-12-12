//
//  AppCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class AppCoordinator {

    // MARK: - Container
    private let container: Container

    // MARK: - Public
    func start() {
        window.rootViewController = BaseTabBarController(container: container)
        window.makeKeyAndVisible()
    }

    // MARK: - Private
    private let window: UIWindow

    // MARK: - Init
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }

}
