//
//  PicturesStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage

class PicturesStorage {

    // MARK: - Public
    func fetchPictures() -> Observable<[Picture]> {
        return getPicturesDocuments()
            .flatMap { Observable.from($0 ?? []) }
            .flatMap { [weak self] pictureDocument -> Observable<(QueryDocumentSnapshot, User?)> in
                let authorId = pictureDocument.data()["authorId"] as? String ?? ""
                let fetchUserRequest = self?.fetchUser(by: authorId).map { author in (pictureDocument, author) }
                return fetchUserRequest ?? Observable.just((pictureDocument, nil))
            }
            .flatMap { [weak self] (pictureDocument, author) -> Observable<(QueryDocumentSnapshot, User?, URL?)> in
                let path = pictureDocument.data()["path"] as? String ?? ""
                let downloadURLRequest = self?.getDownloadURL(with: path)
                    .map { URL in (pictureDocument, author, URL) }
                return downloadURLRequest ?? Observable.just((pictureDocument, user, nil))
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

    func fetchUser(by id: String) -> Observable<User?> {
        return getUserDocument(by: id)
            .flatMap { [weak self] userDocument -> Observable<(DocumentSnapshot?, URL?)> in
                let photoPath = userDocument?.data()?["photoPath"] as? String ?? ""
                let downloadURLRequest = self?.getDownloadURL(with: photoPath)
                    .map { photoURL in (userDocument, photoURL) }
                return downloadURLRequest ?? Observable.just((userDocument, nil))
            }
            .map { (userDocument, photoURL) -> User? in
                guard let userDocument = userDocument else { return nil }
                let id = userDocument.documentID
                let firstName = userDocument.data()?["firstName"] as? String ?? ""
                let lastName = userDocument.data()?["lastName"] as? String ?? ""
                return User(id: id, firstName: firstName, lastName: lastName, photoURL: photoURL)
            }
    }

    // MARK: - Private
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()

    private func getPicturesDocuments() -> Observable<[QueryDocumentSnapshot]?> {
        return Observable.create { [weak self] observer in
            self?.firestore.collection("pictures").getDocuments { (querySnapshot, _) in
                observer.onNext(querySnapshot?.documents)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    private func getUserDocument(by id: String) -> Observable<DocumentSnapshot?> {
        return Observable.create { [weak self] observer in
            self?.firestore.collection("users").document(id).getDocument { (snapshot, _) in
                observer.onNext(snapshot)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    private func getDownloadURL(with path: String) -> Observable<URL?> {
        return Observable.create { [weak self] observer in
            self?.storage.reference(withPath: path).downloadURL { (url, _) in
                observer.onNext(url)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}
