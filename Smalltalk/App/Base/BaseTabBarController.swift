//
//  TabBarCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class BaseTabBarController: UITabBarController {
    let feed = FeedCoordinator()
    let pictures = PicturesCoordinator()
    let messages = MessagesCoordinator()
    let activity = ActivityCoordinator()
    let profile = ProfileCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            feed.navigationController,
            pictures.navigationController,
            messages.navigationController,
            activity.navigationController,
            profile.navigationController
        ]
    }
}
