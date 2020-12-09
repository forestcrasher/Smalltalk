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
    func fetchUrl(by url: String) -> Observable<URL> {
        return Observable.create { [weak self] observer in
            let ref = self?.storage.reference(withPath: url)
            ref?.downloadURL { url, _ in
                if let url = url {
                    observer.onNext(url)
                }
            }
            return Disposables.create()
        }
    }

    // MARK: - Private
    private let storage = Storage.storage()
}
