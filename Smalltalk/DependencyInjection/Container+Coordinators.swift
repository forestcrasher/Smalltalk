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
        autoregister(AppCoordinator.self, argument: UIWindow.self, initializer: AppCoordinator.init)
        autoregister(FeedCoordinator.self, initializer: FeedCoordinator.init)
        autoregister(PicturesCoordinator.self, initializer: PicturesCoordinator.init)
        autoregister(MessagesCoordinator.self, initializer: MessagesCoordinator.init)
        autoregister(ActivityCoordinator.self, initializer: ActivityCoordinator.init)
        autoregister(ProfileCoordinator.self, initializer: ProfileCoordinator.init)
    }

}
