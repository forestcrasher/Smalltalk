//
//  User.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 03.12.2020.
//

import Foundation

struct User: Equatable {

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    let id: String
    let firstName: String
    let lastName: String
    let photoURL: URL?

    var fullName: String { "\(firstName) \(lastName)" }

}
