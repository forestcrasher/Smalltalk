//
//  Post.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation

struct Post: Equatable {

    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }

    let id: String
    let text: String
    let date: Date
    let author: User?
    var likes: [String]
    var reposts: [String]
    var comments: [String]

    var countLikes: Int { likes.count }
    var countReposts: Int { reposts.count }
    var countComments: Int { comments.count }

}
