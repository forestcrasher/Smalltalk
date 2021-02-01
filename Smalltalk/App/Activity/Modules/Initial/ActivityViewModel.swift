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

    // MARK: - Dependencies
    private let notificationsStorage: NotificationsStorage
    weak var coordinator: ActivityCoordinator?

    // MARK: - Public
    let loadAction = PublishRelay<Void>()
    let refreshAction = PublishRelay<Void>()

    let notifications: Driver<[NotificationTableViewCell.Model]>
    let loading: Driver<Bool>
    let refreshing: Driver<Bool>

    // MARK: - Init
    init(container: Container) {
        notificationsStorage = container.resolve(NotificationsStorage.self, argument: container)!

        let driver: Driver<[Notification]> = Observable
            .merge(loadAction.take(1).asObservable(), refreshAction.asObservable())
            .flatMap { [weak notificationsStorage] in (notificationsStorage?.fetchNotifications() ?? Observable.just([])) }
            .asDriver(onErrorJustReturn: [])

        loading = Driver
            .merge(loadAction.take(1).map { _ in true }.asDriver(onErrorJustReturn: false), driver.map { _ in false })

        refreshing = Driver
            .merge(refreshAction.map { _ in true }.asDriver(onErrorJustReturn: false), driver.map { _ in false })

        notifications = driver
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
    }
}
