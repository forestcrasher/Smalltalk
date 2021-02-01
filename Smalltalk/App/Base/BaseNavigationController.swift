//
//  BaseNavigationController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class BaseNavigationController: UINavigationController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = R.color.secondaryBackgroundColor()
        appearance.titleTextAttributes = [.foregroundColor: R.color.labelColor()!]
        appearance.largeTitleTextAttributes = [.foregroundColor: R.color.labelColor()!]
        appearance.shadowImage = UIImage()
        appearance.shadowColor = nil

        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = R.color.secondaryBackgroundColor()
        navigationBar.tintColor = R.color.fillColor()

        view.backgroundColor = R.color.backgroundColor()
    }

}
