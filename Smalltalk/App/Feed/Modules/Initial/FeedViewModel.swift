//
//  FeedViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 02.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

class FeedViewModel {
    var postsStorage: PostsStorage!
    weak var coordinator: FeedCoordinator!

    var test = BehaviorRelay<String>(value: "Test")
}
