//
//  NotificationTableViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 12.12.2020.
//

import UIKit
import Kingfisher

class NotificationTableViewCell: UITableViewCell {

    // MARK: - Public
    struct Model {
        let dispatcherFullName: String?
        let dispatcherPhotoURL: URL?
        let messageText: String?
        let date: Date?
    }

    // MARK: - Private
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = R.color.secondaryBackgroundColor()
        containerView.layer.cornerRadius = 16.0
        return containerView
    }()

    private let userCardView: UserCardView = {
        let userCardView = UserCardView(size: .small)
        userCardView.translatesAutoresizingMaskIntoConstraints = false
        return userCardView
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configure(with model: Model) {
        userCardView.userText = model.dispatcherFullName
        userCardView.messageText = model.messageText
        userCardView.setUserImage(with: model.dispatcherPhotoURL)
        userCardView.setDate(model.date)
    }

    // MARK: - Private
    private func setupUI() {
        backgroundColor = .clear

        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        ])

        containerView.addSubview(userCardView)
        NSLayoutConstraint.activate([
            userCardView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            userCardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            userCardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0),
            userCardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16.0)
        ])
    }

}
