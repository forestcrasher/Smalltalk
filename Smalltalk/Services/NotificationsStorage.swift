//
//  NotificationsStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa
import Swinject

class NotificationsStorage {

    // MARK: - Dependencies
    private let usersStorage: UsersStorage

    // MARK: - Private
    private let firestore = Firestore.firestore()

    // MARK: - Init
    init(container: Container) {
        usersStorage = container.resolve(UsersStorage.self, argument: container)!
    }

    // MARK: - Private
    private func getNotificationDocuments() -> Observable<[QueryDocumentSnapshot]?> {
        return Observable.create { [weak self] observer in
            self?.firestore.collection("notifications").getDocuments { (querySnapshot, _) in
                observer.onNext(querySnapshot?.documents)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    // MARK: - Public
    func fetchNotifications() -> Observable<[Notification]> {
        return getNotificationDocuments()
            .flatMap { Observable.from($0 ?? []) }
            .flatMap { [weak self] notificationDocument -> Observable<(QueryDocumentSnapshot, User?)> in
                let dispatcherId = notificationDocument.data()["dispatcherId"] as? String ?? ""
                let fetchUserRequest = self?.usersStorage.fetchUser(by: dispatcherId)
                    .map { dispatcher in (notificationDocument, dispatcher) }
                return fetchUserRequest ?? Observable.just((notificationDocument, nil))
            }
            .map { (postDocument, dispatcher) -> Notification in
                let id = postDocument.documentID
                let typeRaw = postDocument.data()["type"] as? String ?? ""
                let type = Notification.NotificationType(rawValue: typeRaw) ?? Notification.NotificationType.none
                let date = postDocument.data()["date"] as? Date ?? Date()
                let postId = postDocument.data()["postId"] as? String
                let pictureId = postDocument.data()["pictureId"] as? String
                let commentId = postDocument.data()["commentId"] as? String
                return Notification(
                    id: id,
                    type: type,
                    dispatcher: dispatcher,
                    date: date,
                    postId: postId,
                    pictureId: pictureId,
                    commentId: commentId)
            }
            .toArray()
            .asObservable()
    }

}
