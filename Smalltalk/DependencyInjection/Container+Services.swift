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
    }

}
