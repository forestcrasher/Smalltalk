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
    struct Input {}

    func setup(with input: Input) -> Disposable {
        dialogsStorage
            .fetchDialogs()
            .bind(to: dialogs)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let dialogs = BehaviorRelay<[Dialog]>(value: [])

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
