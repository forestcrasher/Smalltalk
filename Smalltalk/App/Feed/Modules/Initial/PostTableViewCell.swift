//
//  PostTableViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 03.12.2020.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {

    // MARK: - Public
    struct Model {
        let text: String
        let userFullName: String?
        let userPhotoURL: URL?
        let date: Date?
        let countLikes: Int
        let countReposts: Int
        let countComments: Int
        let likeEnabled: Bool
    }

    func configure(with model: Model) {
        textView.text = model.text
        textView.font = .systemFont(ofSize: textView.text.count > 150 ? 16.0 : 24.0)

        headerItemView.userText = model.userFullName
        headerItemView.setUserImage(with: model.userPhotoURL)
        headerItemView.setDate(model.date)
        footerItemView.countLikes = model.countLikes
        footerItemView.countReposts = model.countReposts
        footerItemView.countComments = model.countComments
        footerItemView.likeEnabled = model.likeEnabled
    }

    // MARK: - Private
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = R.color.secondaryBackgroundColor()
        containerView.layer.cornerRadius = 16.0
        contentView.addSubview(containerView)
        return containerView
    }()

    private lazy var headerItemView: HeaderItemView = {
        let headerItemView = HeaderItemView()
        headerItemView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerItemView)
        return headerItemView
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16.0)
        textView.textColor = R.color.labelColor()
        textView.backgroundColor = .clear
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textView)
        return textView
    }()

    private lazy var footerItemView: FooterItemView = {
        let footerItemView = FooterItemView()
        footerItemView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(footerItemView)
        return footerItemView
    }()

    private func setupUI() {
        backgroundColor = .clear

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0)
        ])

        NSLayoutConstraint.activate([
            headerItemView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            headerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            headerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: headerItemView.bottomAnchor, constant: 16.0),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        NSLayoutConstraint.activate([
            footerItemView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8.0),
            footerItemView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
            footerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            footerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
