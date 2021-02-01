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

    // MARK: - Dependencies
    private let postsStorage: PostsStorage
    private let usersStorage: UsersStorage
    weak var coordinator: FeedCoordinator?

    // MARK: - Public
    let loadAction = PublishRelay<Void>()
    let refreshAction = PublishRelay<Void>()

    let posts: Driver<[PostTableViewCell.Model]>
    let loading: Driver<Bool>
    let refreshing: Driver<Bool>

    // MARK: - Init
    init(container: Container) {
        postsStorage = container.resolve(PostsStorage.self, argument: container)!
        usersStorage = container.resolve(UsersStorage.self, argument: container)!

        let driver: Driver<([Post], User?)> = Observable
            .merge(loadAction.take(1).asObservable(), refreshAction.asObservable())
            .flatMap { [weak postsStorage, weak usersStorage] in
                return Observable
                    .combineLatest((postsStorage?.fetchPosts() ?? Observable.just([])), (usersStorage?.fetchCurrentUser() ?? Observable.just(nil)))
            }
            .asDriver(onErrorJustReturn: ([], nil))

        loading = Driver
            .merge(loadAction.take(1).map { _ in true }.asDriver(onErrorJustReturn: false), driver.map { _ in false })

        refreshing = Driver
            .merge(refreshAction.map { _ in true }.asDriver(onErrorJustReturn: false), driver.map { _ in false })

        posts = driver
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
    }

}
