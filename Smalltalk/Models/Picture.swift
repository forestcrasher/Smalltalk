//
//  Picture.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation

struct Picture: Equatable {

    static func == (lhs: Picture, rhs: Picture) -> Bool {
        lhs.id == rhs.id
    }

    let id: String
    let URL: URL?
    let description: String
    let date: Date
    let author: User?
    var likes: [String]
    var reposts: [String]
    var comments: [String]

    var countLikes: Int { likes.count }
    var countReposts: Int { reposts.count }
    var countComments: Int { comments.count }

}
