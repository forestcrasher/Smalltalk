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
    struct Input {
        let refreshDialogs: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        fetchPosts()
        fetchCurrentUser()

        input.refreshDialogs
            .emit(onNext: { [weak self] in
                self?.refreshing.accept(true)
                self?.fetchPosts()
            })
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let posts = BehaviorRelay<[Post]>(value: [])
    let currentUser = BehaviorRelay<User?>(value: nil)
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = BehaviorRelay<Bool>(value: false)

    func fetchPosts() {
        postsStorage
            .fetchPosts()
            .do(onCompleted: { [weak self] in
                self?.loading.accept(false)
                self?.refreshing.accept(false)
            })
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
