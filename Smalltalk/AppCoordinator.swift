//
//  AppCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        window.rootViewController = BaseTabBarController()
        window.makeKeyAndVisible()
    }
}
