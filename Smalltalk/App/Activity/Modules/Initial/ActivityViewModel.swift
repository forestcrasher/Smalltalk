//
//  ActivityViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 12.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject

class ActivityViewModel {

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var notificationsStorage = container.resolve(NotificationsStorage.self, argument: container)!
    weak var coordinator: ActivityCoordinator?

    // MARK: - Setup
    struct Input {
        let refreshDialogs: Signal<Void>
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Public
    let notifications = BehaviorRelay<[NotificationTableViewCell.Model]>(value: [])
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = BehaviorRelay<Bool>(value: false)

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    func setup(with input: Input) -> Disposable {
        let driver: Driver<[Notification]> = notificationsStorage
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
            .map { notifications -> [NotificationTableViewCell.Model] in
                notifications.reduce(into: [], { result, notification in
                    result.append(NotificationTableViewCell.Model(
                        dispatcherFullName: notification.dispatcher?.fullName,
                        dispatcherPhotoURL: notification.dispatcher?.photoURL,
                        messageText: notification.message,
                        date: notification.date
                    ))
                })
            }
            .drive(notifications)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .startWith(())
            .emit(to: notificationsStorage.notificationsRelay)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .map { true }
            .emit(to: refreshing)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

}
