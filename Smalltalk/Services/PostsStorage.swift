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

class PostsStorage {

    private lazy var firestore = Firestore.firestore()

    func fetchPosts() -> Observable<[Post]> {
        return Observable.create { observer in
            let listener = self.firestore.collection("posts").addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    observer.onError(error!)
                    return
                }
                let posts = documents.compactMap { document -> Post? in
                    try? document.data(as: Post.self)
                }
                observer.onNext(posts)
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }

    func fetchAuthor(by ref: DocumentReference) -> Observable<User> {
        return Observable.create { observer in
            let listener = ref.addSnapshotListener { querySnapshot, error in
                guard let document = querySnapshot else {
                    observer.onError(error!)
                    return
                }
                do {
                    let author = try document.data(as: User.self)
                    observer.onNext(author!)
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }

}
