//
//  Dialog.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import Foundation

struct Dialog {

    let id: String
    let type: String
    let recipient: User?
    let lastMessage: Message?
    let participants: [String]

    var countParticipants: Int { participants.count }

}
