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

    // MARK: - Dependencies
    private let usersStorage: UsersStorage
    private let filesStorage: FilesStorage

    // MARK: - Private
    private let firestore = Firestore.firestore()

    // MARK: - Init
    init(container: Container) {
        usersStorage = container.resolve(UsersStorage.self, argument: container)!
        filesStorage = container.resolve(FilesStorage.self)!
    }

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

    func likePicture(by pictureId: String) -> Observable<(String, Bool)> {
        return usersStorage.fetchCurrentUser()
            .flatMap { [weak self] currentUser -> Observable<(String, Bool)> in
                return Observable.create { observer in
                    if let id = currentUser?.id {
                        self?.firestore.collection("pictures").document(pictureId).updateData(["likes": FieldValue.arrayUnion([id])]) { error in
                            if let error = error {
                                observer.onError(error)
                            } else {
                                observer.onNext((pictureId, true))
                                observer.onCompleted()
                            }
                        }
                    }
                    return Disposables.create()
                }
            }
    }

    func unlikePicture(by pictureId: String) -> Observable<(String, Bool)> {
        return usersStorage.fetchCurrentUser()
            .flatMap { [weak self] currentUser -> Observable<(String, Bool)> in
                return Observable.create { observer in
                    if let id = currentUser?.id {
                        self?.firestore.collection("pictures").document(pictureId).updateData(["likes": FieldValue.arrayRemove([id])]) { error in
                            if let error = error {
                                observer.onError(error)
                            } else {
                                observer.onNext((pictureId, false))
                                observer.onCompleted()
                            }
                        }
                    }
                    return Disposables.create()
                }
            }
    }

    // MARK: - Private
    private func getPicturesDocuments() -> Observable<[QueryDocumentSnapshot]?> {
        return Observable.create { [weak self] observer in
            self?.firestore.collection("pictures").getDocuments { (querySnapshot, _) in
                observer.onNext(querySnapshot?.documents)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}
