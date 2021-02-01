//
//  TabBarCoordinator.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import Swinject

class BaseTabBarController: UITabBarController {

    // MARK: - Private
    private let container: Container

    // MARK: - Init
    init(container: Container) {
        self.container = container

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let feed = container.resolve(FeedCoordinator.self, argument: container)!
        let pictures = container.resolve(PicturesCoordinator.self, argument: container)!
        let messages = container.resolve(MessagesCoordinator.self, argument: container)!
        let activity = container.resolve(ActivityCoordinator.self, argument: container)!
        let profile = container.resolve(ProfileCoordinator.self, argument: container)!

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

        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = R.color.secondaryBackgroundColor()
        tabBar.barTintColor = R.color.secondaryBackgroundColor()
        tabBar.tintColor = R.color.tintColor()
        tabBar.unselectedItemTintColor = R.color.fillColor()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }

}
