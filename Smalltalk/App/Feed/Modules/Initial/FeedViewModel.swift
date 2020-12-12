//
//  FeedViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 02.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject

class FeedViewModel {

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var postsStorage: PostsStorage = container.resolve(PostsStorage.self, argument: container)!
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

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
