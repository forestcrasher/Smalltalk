//
//  Dialog.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Dialog: Identifiable, Codable {

    @DocumentID var id: String?
    var type: String
    var authorRef: DocumentReference
    var messagesRefs: [DocumentReference]?
    var participantsRefs: [DocumentReference]?

    var countMessages: Int {
        messagesRefs?.count ?? 0
    }

    var countParticipants: Int {
        participantsRefs?.count ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case type
        case authorRef = "author"
        case messagesRefs = "messages"
        case participantsRefs = "participants"
    }

}
