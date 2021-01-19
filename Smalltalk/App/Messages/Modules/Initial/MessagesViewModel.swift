//
//  MessagesViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 06.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject

class MessagesViewModel {

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var dialogsStorage: DialogsStorage = container.resolve(DialogsStorage.self, argument: container)!
    weak var coordinator: MessagesCoordinator?

    // MARK: - Setup
    struct Input {
        let refreshDialogs: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        fetchDialogs()

        input.refreshDialogs
            .emit(onNext: { [weak self] in
                self?.refreshing.accept(true)
                self?.fetchDialogs()
            })
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let dialogs = BehaviorRelay<[Dialog]>(value: [])
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = BehaviorRelay<Bool>(value: false)

    func fetchDialogs() {
        dialogsStorage
            .fetchDialogs()
            .do(onCompleted: { [weak self] in
                self?.loading.accept(false)
                self?.refreshing.accept(false)
            })
            .bind(to: dialogs)
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
