//
//  TabBarCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class BaseTabBarController: UITabBarController {

    // MARK: - Private
    private let feed = FeedCoordinator()
    private let pictures = PicturesCoordinator()
    private let messages = MessagesCoordinator()
    private let activity = ActivityCoordinator()
    private let profile = ProfileCoordinator()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        feed.start()
        pictures.start()
        messages.start()
        activity.start()
        profile.start()

        viewControllers = [
            feed.navigationController,
            pictures.navigationController,
            messages.navigationController,
            activity.navigationController,
            profile.navigationController
        ]
    }

}
