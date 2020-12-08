//
//  UsersStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class UsersStorage {

    // MARK: - Public
    var currentUserId: String {
        "1qrqguAWA5JZio8Zx8AV"
    }

    func fetchCurrentUser() -> Observable<User> {
        return Observable.create { _ in
            return Disposables.create()
        }
    }

    func fetchUser(by ref: DocumentReference) -> Observable<User> {
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
}
