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
        self.autoregister(PostsStorage.self, initializer: PostsStorage.init).inObjectScope(.container)
        self.autoregister(PicturesStorage.self, initializer: PicturesStorage.init).inObjectScope(.container)
        self.autoregister(DialogsStorage.self, initializer: DialogsStorage.init).inObjectScope(.container)
        self.autoregister(NotificationsStorage.self, initializer: NotificationsStorage.init).inObjectScope(.container)
        self.autoregister(UsersStorage.self, initializer: UsersStorage.init).inObjectScope(.container)
        self.autoregister(FilesStorage.self, initializer: FilesStorage.init).inObjectScope(.container)
    }

}
