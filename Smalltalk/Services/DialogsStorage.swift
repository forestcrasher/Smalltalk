//
//  DialogsStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class DialogsStorage {

    // MARK: - Public
    func fetchDialogs() -> Observable<[Dialog]> {
        return Observable.create { observer in
            let listener = self.firestore.collection("dialogs").addSnapshotListener { querySnapshot, _ in
                if let documents = querySnapshot?.documents {
                    let dialogs = documents.compactMap { document -> Dialog? in
                        try? document.data(as: Dialog.self)
                    }
                    observer.onNext(dialogs)
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

    func fetchMessage(by ref: DocumentReference) -> Observable<Message> {
        return Observable.create { observer in
            let listener = ref.addSnapshotListener { querySnapshot, _ in
                if let message = try? querySnapshot?.data(as: Message.self) {
                    observer.onNext(message)
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
