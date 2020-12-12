//
//  Container+ViewModels.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 02.12.2020.
//

import Swinject
import SwinjectAutoregistration

extension Container {

    func registerViewModels() {
        autoregister(FeedViewModel.self, argument: Container.self, initializer: FeedViewModel.init)
        autoregister(PicturesViewModel.self, argument: Container.self, initializer: PicturesViewModel.init)
        autoregister(MessagesViewModel.self, argument: Container.self, initializer: MessagesViewModel.init)
        autoregister(ActivityViewModel.self, argument: Container.self, initializer: ActivityViewModel.init)
        autoregister(ProfileViewModel.self, argument: Container.self, initializer: ProfileViewModel.init)
    }

}
