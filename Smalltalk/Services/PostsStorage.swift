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

    // MARK: - Public
    func fetchPosts() -> Observable<[Post]> {
        return Observable.create { observer in
            let listener = self.firestore.collection("posts").addSnapshotListener { querySnapshot, _ in
                if let documents = querySnapshot?.documents {
                    let posts = documents.compactMap { document -> Post? in
                        try? document.data(as: Post.self)
                    }
                    observer.onNext(posts)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }

    func fetchAuthor(by ref: DocumentReference) -> Observable<User> {
        return Observable.create { observer in
            let listener = ref.addSnapshotListener { querySnapshot, _ in
                if let author = try? querySnapshot?.data(as: User.self) {
                    observer.onNext(author)
                }
            }
            return Disposables.create {
                listener.remove()
            }
        }
    }

    // MARK: - Private
    private lazy var firestore = Firestore.firestore()

}
