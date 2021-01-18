//
//  PicturesViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 05.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject

class PicturesViewModel {

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var picturesStorage: PicturesStorage = container.resolve(PicturesStorage.self, argument: container)!
    private lazy var usersStorage: UsersStorage = container.resolve(UsersStorage.self, argument: container)!
    weak var coordinator: PicturesCoordinator?

    // MARK: - Setup
    struct Input {
        let refreshDialogs: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        fetchPictures()
        fetchCurrentUser()

        input.refreshDialogs
            .emit(onNext: { [weak self] in
                self?.refreshing.accept(true)
                self?.fetchPictures()
            })
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let pictures = BehaviorRelay<[Picture]>(value: [])
    let currentUser = BehaviorRelay<User?>(value: nil)
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = BehaviorRelay<Bool>(value: false)

    func fetchPictures() {
        pictures.accept([])
        picturesStorage
            .fetchPictures()
            .do(onCompleted: { [weak self] in
                self?.loading.accept(false)
                self?.refreshing.accept(false)
            })
            .bind(to: pictures)
            .disposed(by: disposeBag)
    }

    func fetchCurrentUser() {
        usersStorage
            .fetchCurrentUser()
            .bind(to: currentUser)
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
