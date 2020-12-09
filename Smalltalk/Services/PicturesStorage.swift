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

    // MARK: - Private
    private lazy var firestore = Firestore.firestore()

}
