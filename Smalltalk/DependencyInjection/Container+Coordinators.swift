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
        autoregister(AppCoordinator.self, arguments: UIWindow.self, Container.self, initializer: AppCoordinator.init)
        autoregister(FeedCoordinator.self, argument: Container.self, initializer: FeedCoordinator.init)
        autoregister(PicturesCoordinator.self, argument: Container.self, initializer: PicturesCoordinator.init)
        autoregister(MessagesCoordinator.self, argument: Container.self, initializer: MessagesCoordinator.init)
        autoregister(ActivityCoordinator.self, argument: Container.self, initializer: ActivityCoordinator.init)
        autoregister(ProfileCoordinator.self, argument: Container.self, initializer: ProfileCoordinator.init)
    }

}
