//
//  Notification.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 12.12.2020.
//

import Foundation

struct Notification {

    let id: String
    let type: NotificationType
    let dispatcher: User?
    let date: Date
    let postId: String?
    let pictureId: String?
    let commentId: String?

    var message: String {
        switch type {
        case .none: return ""
        case .acceptedFriendRequest: return "Accepted your friend request"
        case .commentedPicture: return "Commented your picture"
        case .commentedPost: return "Commented your post"
        case .likedPicture: return "Liked your picture"
        case .likedPost: return "Liked your post"
        case .repostedPicture: return "Reposted your picture"
        case .repostedPost: return "Reposted your post"
        }
    }

    enum NotificationType: String {
        case likedPost
        case likedPicture
        case repostedPost
        case repostedPicture
        case commentedPost
        case commentedPicture
        case acceptedFriendRequest
        case none
    }

}
