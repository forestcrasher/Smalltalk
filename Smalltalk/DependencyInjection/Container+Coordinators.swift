//
//  Container+Coordinators.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 02.12.2020.
//

import Swinject
import SwinjectAutoregistration

extension Container {

    func registerCoordinators() {
        self.autoregister(AppCoordinator.self, argument: UIWindow.self, initializer: AppCoordinator.init)
        self.autoregister(FeedCoordinator.self, initializer: FeedCoordinator.init)
        self.autoregister(PicturesCoordinator.self, initializer: PicturesCoordinator.init)
        self.autoregister(MessagesCoordinator.self, initializer: MessagesCoordinator.init)
        self.autoregister(ActivityCoordinator.self, initializer: ActivityCoordinator.init)
        self.autoregister(ProfileCoordinator.self, initializer: ProfileCoordinator.init)
    }

}
