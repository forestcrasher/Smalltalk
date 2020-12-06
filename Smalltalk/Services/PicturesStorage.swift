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
        return Observable.create { observer in
            let listener = self.firestore.collection("pictures").addSnapshotListener { querySnapshot, _ in
                if let documents = querySnapshot?.documents {
                    let pictures = documents.compactMap { document -> Picture? in
                        try? document.data(as: Picture.self)
                    }
                    observer.onNext(pictures)
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

    func downloadImage(url: String) -> Observable<Data> {
        return Observable.create { observer in
                let ref = self.storage.reference(withPath: url)
                ref.getData(maxSize: self.maxSize) { data, _ in
                    if let data = data {
                        observer.onNext(data)
                    }
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }

    // MARK: - Private
    private lazy var firestore = Firestore.firestore()
    private lazy var storage = Storage.storage()

    private let maxSize: Int64 = 10 * 1024 * 1024

}
