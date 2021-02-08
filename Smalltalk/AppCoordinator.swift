//
//  AppCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class AppCoordinator {

    // MARK: - Private
    private let window: UIWindow
    private let container: Container

    // MARK: - Init
    init(window: UIWindow, container: Container) {
        self.window = window
        self.container = container
    }

    // MARK: - Public
    func start() {
        window.rootViewController = BaseTabBarController(container: container)
        window.makeKeyAndVisible()
    }

}
