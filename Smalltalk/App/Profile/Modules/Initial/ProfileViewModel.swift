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

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var usersStorage: UsersStorage = container.resolve(UsersStorage.self, argument: container)!
    weak var coordinator: ProfileCoordinator!

    // MARK: - Setup
    struct Input {}

    func setup(with input: Input) -> Disposable {
        usersStorage
            .fetchCurrentUser()
            .bind(to: currentUser)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let currentUser = BehaviorRelay<User?>(value: nil)

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }
}
