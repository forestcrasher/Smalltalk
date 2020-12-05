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
    }

}
