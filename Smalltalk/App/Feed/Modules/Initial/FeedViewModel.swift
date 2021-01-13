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
    private lazy var usersStorage: UsersStorage = container.resolve(UsersStorage.self, argument: container)!
    weak var coordinator: FeedCoordinator?

    // MARK: - Setup
    struct Input {}

    func setup(with input: Input) -> Disposable {
        fetchPosts()
        fetchCurrentUser()
        return Disposables.create()
    }

    // MARK: - Public
    let posts = BehaviorRelay<[Post]>(value: [])
    let currentUser = BehaviorRelay<User?>(value: nil)
    let loading = BehaviorRelay<Bool>(value: true)

    func fetchPosts() {
        loading.accept(true)
        posts.accept([])
        postsStorage
            .fetchPosts()
            .do(onCompleted: { [weak self] in self?.loading.accept(false) })
            .bind(to: posts)
            .disposed(by: disposeBag)
    }

    func fetchCurrentUser() {
        usersStorage
            .fetchCurrentUser()
            .bind(to: currentUser)
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
