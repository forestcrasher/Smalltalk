//
//  User.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 03.12.2020.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {

    @DocumentID var id: String?
    let firstName: String
    let lastName: String
    let photoUrl: String

    var fullName: String {
        "\(firstName) \(lastName)"
    }

}
