//
//  PostsStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage

class PostsStorage {

    // MARK: - Public
    func fetchPosts() -> Observable<[Post]> {
        return getPostsDocuments()
            .flatMap { Observable.from($0 ?? []) }
            .flatMap { [weak self] postDocument -> Observable<(QueryDocumentSnapshot, User?)> in
                let authorId = postDocument.data()["authorId"] as? String ?? ""
                let fetchUserRequest = self?.fetchUser(by: authorId).map { author in (postDocument, author) }
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

    private func getPostsDocuments() -> Observable<[QueryDocumentSnapshot]?> {
        return Observable.create { [weak self] observer in
            self?.firestore.collection("posts").getDocuments { (querySnapshot, _) in
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
