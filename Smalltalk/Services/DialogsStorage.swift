//
//  DialogsStorage.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa
import Swinject

class DialogsStorage {

    // MARK: - Dependencies
    private let usersStorage: UsersStorage

    // MARK: - Private
    private let firestore = Firestore.firestore()

    // MARK: - Init
    init(container: Container) {
        usersStorage = container.resolve(UsersStorage.self, argument: container)!
    }

    // MARK: - Public
    func fetchDialogs() -> Observable<[Dialog]> {
        return getDialogsDocuments()
            .flatMap { Observable.from($0 ?? []) }
            .flatMap { [weak self] dialogDocument -> Observable<(QueryDocumentSnapshot, User?)> in
                let participants = dialogDocument.data()["participants"] as? [String] ?? []
                let recipientId = participants.first ?? ""
                let fetchUserRequest = self?.usersStorage.fetchUser(by: recipientId)
                    .map { recipient in (dialogDocument, recipient) }
                return fetchUserRequest ?? Observable.just((dialogDocument, nil))
            }
            .flatMap { [weak self] (dialogDocument, recipient)  -> Observable<(QueryDocumentSnapshot, User?, Message?)> in
                let dialogId = dialogDocument.documentID
                let fetchLastMessageRequest = self?.fetchLastMessage(by: dialogId)
                    .map { lastMessage in (dialogDocument, recipient, lastMessage) }
                return fetchLastMessageRequest ?? Observable.just((dialogDocument, recipient, nil))
            }
            .map { (postDocument, recipient, lastMessage) -> Dialog in
                let id = postDocument.documentID
                let type = postDocument.data()["type"] as? String ?? ""
                let participants = postDocument.data()["type"] as? [String] ?? []
                return Dialog(id: id, type: type, recipient: recipient, lastMessage: lastMessage, participants: participants)
            }
            .toArray()
            .asObservable()
    }

    func fetchLastMessage(by dialogId: String) -> Observable<Message?> {
        return getLastMessageDocument(by: dialogId)
            .flatMap { [weak self] messageDocument -> Observable<(DocumentSnapshot?, User?)> in
                let authorId = messageDocument?.data()?["authorId"] as? String ?? ""
                let fetchUserRequest = self?.usersStorage.fetchUser(by: authorId)
                    .map { author in (messageDocument, author) }
                return fetchUserRequest ?? Observable.just((messageDocument, nil))
            }
            .map { (messageDocument, author) -> Message? in
                guard let messageDocument = messageDocument else { return nil }
                let id = messageDocument.documentID
                let text = messageDocument.data()?["text"] as? String ?? ""
                let date = messageDocument.data()?["date"] as? Date ?? Date()
                let isRead = messageDocument.data()?["isRead"] as? Bool ?? false
                return Message(id: id, text: text, date: date, isRead: isRead, author: author)
            }
    }

    // MARK: - Private
    private func getDialogsDocuments() -> Observable<[QueryDocumentSnapshot]?> {
        return Observable.create { [weak self] observer in
            self?.firestore
                .collection("dialogs")
                .getDocuments { (querySnapshot, _) in
                    observer.onNext(querySnapshot?.documents)
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }

    private func getLastMessageDocument(by dialogId: String) -> Observable<DocumentSnapshot?> {
        return Observable.create { [weak self] observer in
            self?.firestore
                .collection("dialogs/\(dialogId)/messages")
                .order(by: "date", descending: true)
                .limit(to: 1)
                .getDocuments { (querySnapshot, _) in
                    observer.onNext(querySnapshot?.documents.first)
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }

}
