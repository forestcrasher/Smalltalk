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

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var usersStorage = container.resolve(UsersStorage.self, argument: container)!

    // MARK: - Private
    private let firestore = Firestore.firestore()
    private let disposeBag = DisposeBag()

    // MARK: - Public
    let postsRelay = PublishRelay<Void>()
    let getData = PublishRelay<[Post]>()

    // MARK: - Init
    init(container: Container) {
        self.container = container

        postsRelay
            .flatMap { [weak self] in (self?.fetchPosts() ?? Observable.just([])) }
            .bind(to: getData)
            .disposed(by: disposeBag)
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

}
