//
//  FooterItemView.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 15.12.2020.
//

import UIKit

class FooterItemView: UIView {

    // MARK: - Private
    private func setupUI() {
        heightAnchor.constraint(equalToConstant: 48.0).isActive = true
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
