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
import Swinject

class UsersStorage {

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var filesStorage = container.resolve(FilesStorage.self)!

    // MARK: - Private
    private let firestore = Firestore.firestore()
    private let disposeBag = DisposeBag()

    // MARK: - Public
    var currentUserId: String { "1qrqguAWA5JZio8Zx8AV" }

    let userRelay = PublishRelay<Void>()
    let getData = PublishRelay<User?>()

    // MARK: - Init
    init(container: Container) {
        self.container = container

        userRelay
            .flatMap { [weak self] in self?.fetchCurrentUser() ?? Observable.just(nil) }
            .bind(to: getData)
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private func getUserDocument(by id: String) -> Observable<DocumentSnapshot?> {
        return Observable.create { [weak self] observer in
            self?.firestore.collection("users").document(id).getDocument { (snapshot, _) in
                observer.onNext(snapshot)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - Public
    func fetchCurrentUser() -> Observable<User?> {
        return fetchUser(by: currentUserId)
    }

    func fetchUser(by id: String) -> Observable<User?> {
        return getUserDocument(by: id)
            .flatMap { [weak self] userDocument -> Observable<(DocumentSnapshot?, URL?)> in
                let photoPath = userDocument?.data()?["photoPath"] as? String ?? ""
                let downloadURLRequest = self?.filesStorage.getDownloadURL(with: photoPath)
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

}
