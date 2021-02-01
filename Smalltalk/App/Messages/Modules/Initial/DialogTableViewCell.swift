//
//  DialogTableViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 07.12.2020.
//

import UIKit
import Kingfisher

class DialogTableViewCell: UITableViewCell {

    // MARK: - Private
    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = R.color.secondaryBackgroundColor()
        containerView.layer.cornerRadius = 16.0
        return containerView
    }()

    private let userCardView: UserCardView = {
        let userCardView = UserCardView(size: .large)
        userCardView.translatesAutoresizingMaskIntoConstraints = false
        return userCardView
    }()

    // MARK: - Public
    struct Model {
        let recipientFullName: String?
        let recipientPhotoURL: URL?
        let lastMessageText: String?
        let date: Date?
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    // MARK: - Public
    func configure(with model: Model) {
        userCardView.userText = model.recipientFullName
        userCardView.messageText = model.lastMessageText
        userCardView.setUserImage(with: model.recipientPhotoURL)
        userCardView.setDate(model.date)
    }
}
