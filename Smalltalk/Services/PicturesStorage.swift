//
//  PicturesStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa
import Swinject

class PicturesStorage {

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var usersStorage: UsersStorage = container.resolve(UsersStorage.self, argument: container)!
    private lazy var filesStorage: FilesStorage = container.resolve(FilesStorage.self)!

    // MARK: - Public
    func fetchPictures() -> Observable<[Picture]> {
        return getPicturesDocuments()
            .flatMap { Observable.from($0 ?? []) }
            .flatMap { [weak self] pictureDocument -> Observable<(QueryDocumentSnapshot, User?)> in
                let authorId = pictureDocument.data()["authorId"] as? String ?? ""
                let fetchUserRequest = self?.usersStorage.fetchUser(by: authorId).map { author in (pictureDocument, author) }
                return fetchUserRequest ?? Observable.just((pictureDocument, nil))
            }
            .flatMap { [weak self] (pictureDocument, author) -> Observable<(QueryDocumentSnapshot, User?, URL?)> in
                let path = pictureDocument.data()["path"] as? String ?? ""
                let downloadURLRequest = self?.filesStorage.getDownloadURL(with: path)
                    .map { URL in (pictureDocument, author, URL) }
                return downloadURLRequest ?? Observable.just((pictureDocument, author, nil))
            }
            .map { (pictureDocument, author, URL) -> Picture in
                let id = pictureDocument.documentID
                let description = pictureDocument.data()["description"] as? String ?? ""
                let date = pictureDocument.data()["date"] as? Date ?? Date()
                let likes = pictureDocument.data()["likes"] as? [String] ?? []
                let reposts = pictureDocument.data()["reposts"] as? [String] ?? []
                let comments = pictureDocument.data()["comments"] as? [String] ?? []
                return Picture(id: id, URL: URL, description: description, date: date, author: author, likes: likes, reposts: reposts, comments: comments)
            }
            .toArray()
            .asObservable()
    }

    // MARK: - Private
    private let firestore = Firestore.firestore()

    private func getPicturesDocuments() -> Observable<[QueryDocumentSnapshot]?> {
        return Observable.create { [weak self] observer in
            self?.firestore.collection("pictures").getDocuments { (querySnapshot, _) in
                observer.onNext(querySnapshot?.documents)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
