//
//  PostsStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa
import Swinject

class PostsStorage {

    // MARK: - Dependencies
    private let usersStorage: UsersStorage

    // MARK: - Private
    private let firestore = Firestore.firestore()

    // MARK: - Init
    init(container: Container) {
        usersStorage = container.resolve(UsersStorage.self, argument: container)!
    }

    // MARK: - Private
    private func getPostsDocuments() -> Observable<[QueryDocumentSnapshot]?> {
        return Observable.create { [weak self] observer in
            self?.firestore.collection("posts").getDocuments { (querySnapshot, _) in
                observer.onNext(querySnapshot?.documents)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - Public
    func fetchPosts() -> Observable<[Post]> {
        return getPostsDocuments()
            .flatMap { Observable.from($0 ?? []) }
            .flatMap { [weak self] postDocument -> Observable<(QueryDocumentSnapshot, User?)> in
                let authorId = postDocument.data()["authorId"] as? String ?? ""
                let fetchUserRequest = self?.usersStorage.fetchUser(by: authorId).map { author in (postDocument, author) }
                return fetchUserRequest ?? Observable.just((postDocument, nil))
            }
            .map { (postDocument, author) -> Post in
                let id = postDocument.documentID
                let text = postDocument.data()["text"] as? String ?? ""
                let date = postDocument.data()["date"] as? Date ?? Date()
                let likes = postDocument.data()["likes"] as? [String] ?? []
                let reposts = postDocument.data()["reposts"] as? [String] ?? []
                let comments = postDocument.data()["comments"] as? [String] ?? []
                return Post(id: id, text: text, date: date, author: author, likes: likes, reposts: reposts, comments: comments)
            }
            .toArray()
            .asObservable()
    }

    func likePost(by postId: String) -> Observable<(String, Bool)> {
        return usersStorage.fetchCurrentUser()
            .flatMap { [weak self] currentUser -> Observable<(String, Bool)> in
                return Observable.create { observer in
                    if let id = currentUser?.id {
                        self?.firestore.collection("posts").document(postId).updateData(["likes": FieldValue.arrayUnion([id])]) { error in
                            if let error = error {
                                observer.onError(error)
                            } else {
                                observer.onNext((id, true))
                                observer.onCompleted()
                            }
                        }
                    }
                    return Disposables.create()
                }
            }
    }

    func unlikePost(by postId: String) -> Observable<(String, Bool)> {
        return usersStorage.fetchCurrentUser()
            .flatMap { [weak self] currentUser -> Observable<(String, Bool)> in
                return Observable.create { observer in
                    if let id = currentUser?.id {
                        self?.firestore.collection("posts").document(postId).updateData(["likes": FieldValue.arrayRemove([id])]) { error in
                            if let error = error {
                                observer.onError(error)
                            } else {
                                observer.onNext((id, false))
                                observer.onCompleted()
                            }
                        }
                    }
                    return Disposables.create()
                }
            }
    }

}
