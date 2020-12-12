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

class DialogsStorage {

    // MARK: - Public
    func fetchDialogs() -> Observable<[Dialog]> {
        return getDialogsDocuments()
            .flatMap { Observable.from($0 ?? []) }
            .flatMap { [weak self] dialogDocument -> Observable<(QueryDocumentSnapshot, User?)> in
                let participants = dialogDocument.data()["participants"] as? [String] ?? []
                let recipientId = participants.first ?? ""
                let fetchUserRequest = self?.fetchUser(by: recipientId)
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

    func fetchUser(by id: String) -> Observable<User?> {
        return getUserDocument(by: id)
            .flatMap { [weak self] userDocument -> Observable<(DocumentSnapshot?, URL?)> in
                let photoPath = userDocument?.data()?["photoPath"] as? String ?? ""
                let downloadURLRequest = self?.getDownloadURL(with: photoPath)
                    .map { photoURL in (userDocument, photoURL) }
                return downloadURLRequest ?? Observable.just((userDocument, nil))
            }
            .map { (userDocument, photoURL) -> User? in
                guard let userDocument = userDocument else { return nil }
                let id = userDocument.documentID
                let firstName = userDocument.data()?["firstName"] as? String ?? ""
                let lastName = userDocument.data()?["lastName"] as? String ?? ""
                return User(id: id, firstName: firstName, lastName: lastName, photoURL: photoURL)
            }
    }

    func fetchLastMessage(by dialogId: String) -> Observable<Message?> {
        return getLastMessageDocument(by: dialogId)
            .flatMap { [weak self] messageDocument -> Observable<(DocumentSnapshot?, User?)> in
                let authorId = messageDocument?.data()?["author"] as? String ?? ""
                let fetchUserRequest = self?.fetchUser(by: authorId)
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
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()

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

    private func getUserDocument(by id: String) -> Observable<DocumentSnapshot?> {
        return Observable.create { [weak self] observer in
            self?.firestore
                .collection("users")
                .document(id)
                .getDocument { (snapshot, _) in
                    observer.onNext(snapshot)
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }

    private func getDownloadURL(with path: String) -> Observable<URL?> {
        return Observable.create { [weak self] observer in
            self?.storage
                .reference(withPath: path)
                .downloadURL { (url, _) in
                    observer.onNext(url)
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }
}
