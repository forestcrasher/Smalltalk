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
    private lazy var dialogsStorage = container.resolve(DialogsStorage.self, argument: container)!
    weak var coordinator: MessagesCoordinator?

    // MARK: - Setup
    struct Input {
        let refreshDialogs: Signal<Void>
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Public
    let dialogs = BehaviorRelay<[DialogTableViewCell.Model]>(value: [])
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = BehaviorRelay<Bool>(value: false)

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    func setup(with input: Input) -> Disposable {
        let driver: Driver<[Dialog]> = dialogsStorage
            .getData
            .asDriver(onErrorJustReturn: [])

        driver
            .map { _ in false }
            .drive(loading)
            .disposed(by: disposeBag)

        driver
            .map { _ in false }
            .drive(refreshing)
            .disposed(by: disposeBag)

        driver
            .map { dialogs -> [DialogTableViewCell.Model] in
                dialogs.reduce(into: [], { result, dialog in
                    result.append(DialogTableViewCell.Model(
                        recipientFullName: dialog.recipient?.fullName,
                        recipientPhotoURL: dialog.recipient?.photoURL,
                        lastMessageText: dialog.lastMessage?.text,
                        date: dialog.lastMessage?.date
                    ))
                })
            }
            .drive(dialogs)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .startWith(())
            .emit(to: dialogsStorage.dialogsRelay)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .map { true }
            .emit(to: refreshing)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

}
