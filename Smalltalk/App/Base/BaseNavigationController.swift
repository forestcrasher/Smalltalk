//
//  BaseNavigationController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit

class BaseNavigationController: UINavigationController {

    // MARK: - Private
    private func setupUI() {
        navigationBar.isTranslucent = false
        navigationBar.backgroundColor = R.color.secondaryBackgroundColor()
        navigationBar.barTintColor = R.color.secondaryBackgroundColor()
        navigationBar.titleTextAttributes = [.foregroundColor: R.color.labelColor()!]
        navigationBar.tintColor = R.color.fillColor()
        navigationBar.shadowImage = UIImage()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}
