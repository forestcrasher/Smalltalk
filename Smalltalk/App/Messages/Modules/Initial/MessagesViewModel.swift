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

    // MARK: - Dependencies
    private var dialogsStorage: DialogsStorage
    weak var coordinator: MessagesCoordinator?

    // MARK: - Public
    let isLoaded = BehaviorRelay<Bool>(value: false)
    let loadAction = PublishRelay<Void>()
    let refreshAction = PublishRelay<Void>()

    let dialogs: Driver<[DialogTableViewCell.Model]>
    let loading: Driver<Bool>
    let refreshing: Driver<Bool>

    // MARK: - Init
    init(container: Container) {
        dialogsStorage = container.resolve(DialogsStorage.self, argument: container)!

        let driver: Driver<[Dialog]> = dialogsStorage
            .getData
            .asDriver(onErrorJustReturn: [])

        let load = loadAction
            .do(onNext: { [dialogsStorage] in
                dialogsStorage.dialogsRelay.accept(())
            })

        loading = Driver
            .merge(load.map { _ in true }.asDriver(onErrorJustReturn: false), driver.map { _ in false })

        let refresh = refreshAction
            .do(onNext: { [dialogsStorage] in
                dialogsStorage.dialogsRelay.accept(())
            })

        refreshing = Driver
            .merge(refresh.map { _ in true }.asDriver(onErrorJustReturn: false), driver.map { _ in false })

        dialogs = driver
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
    }

}
