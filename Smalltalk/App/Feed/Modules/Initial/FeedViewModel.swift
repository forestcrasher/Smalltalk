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
    private lazy var postsStorage = container.resolve(PostsStorage.self, argument: container)!
    private lazy var usersStorage = container.resolve(UsersStorage.self, argument: container)!
    weak var coordinator: FeedCoordinator?

    // MARK: - Setup
    struct Input {
        let refreshDialogs: Signal<Void>
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Public
    let posts = BehaviorRelay<[PostTableViewCell.Model]>(value: [])
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = BehaviorRelay<Bool>(value: false)

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    func setup(with input: Input) -> Disposable {
        let driver: Driver<([Post], User?)> = Observable
            .combineLatest(postsStorage.getData, usersStorage.getData)
            .asDriver(onErrorJustReturn: ([], nil))

        driver
            .map { _ in false }
            .drive(loading)
            .disposed(by: disposeBag)

        driver
            .map { _ in false }
            .drive(refreshing)
            .disposed(by: disposeBag)

        driver
            .map { data -> [PostTableViewCell.Model] in
                let (posts, currentUser) = data
                return posts.reduce(into: [], { result, post in
                    result.append(PostTableViewCell.Model(
                        text: post.text,
                        userFullName: post.author?.fullName,
                        userPhotoURL: post.author?.photoURL,
                        date: post.date,
                        countLikes: post.countLikes,
                        countReposts: post.countReposts,
                        countComments: post.countComments,
                        likeEnabled: post.likes.contains(currentUser?.id ?? "")
                    ))
                })
            }
            .drive(posts)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .startWith(())
            .emit(to: postsStorage.postsRelay)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .startWith(())
            .emit(to: usersStorage.userRelay)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .map { true }
            .emit(to: refreshing)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

}
