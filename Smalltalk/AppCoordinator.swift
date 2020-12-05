//
//  AppCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class AppCoordinator {

    // MARK: - Public
    func start() {
        window.rootViewController = BaseTabBarController()
        window.makeKeyAndVisible()
    }

    // MARK: - Private
    private let window: UIWindow

    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
    }

}
