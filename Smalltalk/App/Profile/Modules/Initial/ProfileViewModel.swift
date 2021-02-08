//
//  ProfileViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 12.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject

class ProfileViewModel {

    // MARK: - Dependencies
    private let usersStorage: UsersStorage
    weak var coordinator: ProfileCoordinator?

    // MARK: - Public
    let loadAction = PublishRelay<Void>()

    let currentUser: Driver<User?>

    // MARK: - Init
    init(container: Container) {
        usersStorage = container.resolve(UsersStorage.self, argument: container)!

        currentUser = loadAction
            .take(1)
            .asObservable()
            .flatMap { [weak usersStorage] in
                usersStorage?.fetchCurrentUser() ?? Observable.just(nil)
            }
            .asDriver(onErrorJustReturn: nil)
    }
}
