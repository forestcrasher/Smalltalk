//
//  FilesStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 08.12.2020.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class FilesStorage {

    // MARK: - Public
    func getDownloadURL(with path: String) -> Observable<URL?> {
        return Observable.create { [weak self] observer in
            self?.storage.reference(withPath: path).downloadURL { (url, _) in
                observer.onNext(url)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - Private
    private let storage = Storage.storage()
}
