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
        autoregister(PostsStorage.self, initializer: PostsStorage.init).inObjectScope(.container)
        autoregister(PicturesStorage.self, initializer: PicturesStorage.init).inObjectScope(.container)
        autoregister(DialogsStorage.self, initializer: DialogsStorage.init).inObjectScope(.container)
        autoregister(NotificationsStorage.self, initializer: NotificationsStorage.init).inObjectScope(.container)
        autoregister(UsersStorage.self, initializer: UsersStorage.init).inObjectScope(.container)
        autoregister(FilesStorage.self, initializer: FilesStorage.init).inObjectScope(.container)
    }

}
