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
        autoregister(PostTableViewCellViewModel.self, argument: Post.self, initializer: PostTableViewCellViewModel.init)
        autoregister(PicturesViewModel.self, initializer: PicturesViewModel.init)
        autoregister(MessagesViewModel.self, initializer: MessagesViewModel.init)
        autoregister(DialogTableViewCellViewModel.self, argument: Dialog.self, initializer: DialogTableViewCellViewModel.init)
    }

}
