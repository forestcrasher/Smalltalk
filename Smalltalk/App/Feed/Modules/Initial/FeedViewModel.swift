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
    let tapLikeAction = PublishRelay<(String, Bool)>()

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

        let driverUpdateLike: Driver<([Post], User?)> = tapLikeAction
            .flatMap { [weak postsStorage] (postId, likeEnabled) in
                return likeEnabled
                    ? (postsStorage?.unlikePost(by: postId) ?? Observable.just((postId, true)))
                    : (postsStorage?.likePost(by: postId) ?? Observable.just((postId, false)))
            }
            .flatMap { (postId, likeEnabled) in
                return driver.map { data -> ([Post], User?) in
                    let (posts, currentUser) = data
                    let newPosts = posts.map { post -> Post in
                        var newPost = post
                        if newPost.id == postId {
                            if likeEnabled {
                                if let id = currentUser?.id {
                                    newPost.likes.append(id)
                                }
                            } else {
                                if let id = currentUser?.id, let index = newPost.likes.firstIndex(of: id) {
                                    newPost.likes.remove(at: index)
                                }
                            }
                        }
                        return newPost
                    }
                    return (newPosts, currentUser)
                }
            }
            .asDriver(onErrorJustReturn: ([], nil))

        posts = Driver
            .merge(driver, driverUpdateLike)
            .map { data -> [PostTableViewCell.Model] in
                let (posts, currentUser) = data
                return posts.reduce(into: [], { result, post in
                    result.append(PostTableViewCell.Model(
                        postId: post.id,
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
