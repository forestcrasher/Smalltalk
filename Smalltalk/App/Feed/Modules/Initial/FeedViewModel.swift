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

    // MARK: - Dependencies
    private var postsStorage: PostsStorage = AppDelegate.container.resolve(PostsStorage.self)!
    weak var coordinator: FeedCoordinator!

    // MARK: - Setup
    struct Input {}

    func setup(with input: Input) -> Disposable {
        postsStorage
            .fetchPosts()
            .bind(to: posts)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let posts = BehaviorRelay<[Post]>(value: [])

    // MARK: - Private
    private let disposeBag = DisposeBag()

}
