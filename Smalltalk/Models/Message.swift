//
//  Message.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation

struct Message {

    let id: String
    let text: String
    let date: Date
    let isRead: Bool
    let author: User?

}
