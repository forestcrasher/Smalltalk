//
//  Post.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {

    @DocumentID var id: String?
    var text: String
    var date: Date
    var authorRef: DocumentReference
    var likesRefs: [DocumentReference]?
    var repostsRefs: [DocumentReference]?
    var commentsRefs: [DocumentReference]?

    var countLikes: Int {
        likesRefs?.count ?? 0
    }

    var countReposts: Int {
        repostsRefs?.count ?? 0
    }

    var countComments: Int {
        commentsRefs?.count ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case text
        case date
        case authorRef = "author"
        case likesRefs = "likes"
        case repostsRefs = "reposts"
        case commentsRefs = "comments"
    }

}
