//
//  FilesStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 08.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseStorage

class FilesStorage {

    // MARK: - Public
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
    private lazy var storage = Storage.storage()

    private let maxSize: Int64 = 10 * 1024 * 1024
}
