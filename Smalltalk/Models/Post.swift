//
//  Post.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation

struct Post {

    let id: String
    let text: String
    let date: Date
    let author: User?
    var likes: [String]
    let reposts: [String]
    let comments: [String]

    var countLikes: Int { likes.count }
    var countReposts: Int { reposts.count }
    var countComments: Int { comments.count }

}
