//
//  Container+Services.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 02.12.2020.
//

import Foundation

import Swinject
import SwinjectAutoregistration

extension Container {

    func registerServices() {
        autoregister(PostsStorage.self, argument: Container.self, initializer: PostsStorage.init).inObjectScope(.container)
        autoregister(PicturesStorage.self, argument: Container.self, initializer: PicturesStorage.init).inObjectScope(.container)
        autoregister(DialogsStorage.self, argument: Container.self, initializer: DialogsStorage.init).inObjectScope(.container)
        autoregister(NotificationsStorage.self, argument: Container.self, initializer: NotificationsStorage.init).inObjectScope(.container)
        autoregister(UsersStorage.self, argument: Container.self, initializer: UsersStorage.init).inObjectScope(.container)
        autoregister(FilesStorage.self, initializer: FilesStorage.init).inObjectScope(.container)
    }

}
