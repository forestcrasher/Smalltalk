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
    private lazy var notificationsStorage: NotificationsStorage = container.resolve(NotificationsStorage.self, argument: container)!
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

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
