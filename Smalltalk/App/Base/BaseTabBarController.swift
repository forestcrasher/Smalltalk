//
//  TabBarCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class BaseTabBarController: UITabBarController {

    // MARK: - Container
    private let container: Container

    // MARK: - Private
    private lazy var feed = container.resolve(FeedCoordinator.self, argument: container)!
    private lazy var pictures = container.resolve(PicturesCoordinator.self, argument: container)!
    private lazy var messages = container.resolve(MessagesCoordinator.self, argument: container)!
    private lazy var activity = container.resolve(ActivityCoordinator.self, argument: container)!
    private lazy var profile = container.resolve(ProfileCoordinator.self, argument: container)!

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

        selectedIndex = 2
    }

    init(container: Container) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
