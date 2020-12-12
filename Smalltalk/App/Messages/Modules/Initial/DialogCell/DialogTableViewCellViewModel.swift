//
//  DialogTableViewCellViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 07.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

class DialogTableViewCellViewModel {

    // MARK: - Dependencies
    private var dialogsStorage: DialogsStorage = AppDelegate.container.resolve(DialogsStorage.self)!
    private var usersStorage: UsersStorage = AppDelegate.container.resolve(UsersStorage.self)!

    // MARK: - Public

    let dialog: BehaviorRelay<Dialog>
    let participant = BehaviorRelay<User?>(value: nil)
    let message = BehaviorRelay<Message?>(value: nil)

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(dialog: Dialog) {
        self.dialog = BehaviorRelay(value: dialog)

        if let lastMessageRef = dialog.messagesRefs?.last {
            dialogsStorage
                .fetchMessage(by: lastMessageRef)
                .bind(to: message)
                .disposed(by: disposeBag)
        }
    }

}
