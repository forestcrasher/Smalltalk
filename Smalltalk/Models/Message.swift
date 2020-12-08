//
//  Message.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable {

    @DocumentID var id: String?
    var text: String
    var date: Date
    var isRead: Bool
    var authorRef: DocumentReference

    enum CodingKeys: String, CodingKey {
        case text
        case date
        case isRead
        case authorRef = "author"
    }

}
