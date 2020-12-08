//
//  MessagesViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 06.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

class MessagesViewModel {

    // MARK: - Dependencies
    private var dialogsStorage: DialogsStorage = AppDelegate.container.resolve(DialogsStorage.self)!
    weak var coordinator: MessagesCoordinator!

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

}
