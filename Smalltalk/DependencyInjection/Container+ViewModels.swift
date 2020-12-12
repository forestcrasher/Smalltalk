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
        autoregister(FeedViewModel.self, initializer: FeedViewModel.init)
        autoregister(PicturesViewModel.self, initializer: PicturesViewModel.init)
        autoregister(MessagesViewModel.self, initializer: MessagesViewModel.init)
        autoregister(ActivityViewModel.self, initializer: ActivityViewModel.init)
    }

}
