//
//  ActivityViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 12.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

class ActivityViewModel {

    // MARK: - Dependencies
    private var notificationsStorage: NotificationsStorage = AppDelegate.container.resolve(NotificationsStorage.self)!
    weak var coordinator: ActivityCoordinator!

    // MARK: - Setup
    struct Input {}

    func setup(with input: Input) -> Disposable {
        notificationsStorage
            .fetchNotifications()
            .bind(to: notifications)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let notifications = BehaviorRelay<[Notification]>(value: [])

    // MARK: - Private
    private let disposeBag = DisposeBag()

}
