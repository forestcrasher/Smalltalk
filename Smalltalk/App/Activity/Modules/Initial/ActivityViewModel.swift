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
    weak var coordinator: ActivityCoordinator?

    // MARK: - Setup
    struct Input {
        let refreshDialogs: Signal<Void>
    }

    func setup(with input: Input) -> Disposable {
        fetchNotifications()

        input.refreshDialogs
            .emit(onNext: { [weak self] in
                self?.refreshing.accept(true)
                self?.fetchNotifications()
            })
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let notifications = BehaviorRelay<[Notification]>(value: [])
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = BehaviorRelay<Bool>(value: false)

    func fetchNotifications() {
        notificationsStorage
            .fetchNotifications()
            .do(onCompleted: { [weak self] in
                self?.loading.accept(false)
                self?.refreshing.accept(false)
            })
            .bind(to: notifications)
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
