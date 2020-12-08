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
        self.autoregister(FeedViewModel.self, initializer: FeedViewModel.init)
        self.autoregister(PostTableViewCellViewModel.self, argument: Post.self, initializer: PostTableViewCellViewModel.init)
        self.autoregister(PicturesViewModel.self, initializer: PicturesViewModel.init)
        self.autoregister(PictureCollectionViewCellViewModel.self, argument: Picture.self, initializer: PictureCollectionViewCellViewModel.init)
        self.autoregister(MessagesViewModel.self, initializer: MessagesViewModel.init)
        self.autoregister(DialogTableViewCellViewModel.self, argument: Dialog.self, initializer: DialogTableViewCellViewModel.init)
    }

}
