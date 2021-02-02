//
//  PostTableViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 03.12.2020.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {

    // MARK: - Private
    private var postId: String?
    private var likeEnabled: Bool?

    private let containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = R.color.secondaryBackgroundColor()
        containerView.layer.cornerRadius = 16.0
        return containerView
    }()

    private let headerItemView: HeaderItemView = {
        let headerItemView = HeaderItemView()
        headerItemView.translatesAutoresizingMaskIntoConstraints = false
        return headerItemView
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16.0)
        textView.textColor = R.color.labelColor()
        textView.backgroundColor = .clear
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let footerItemView: FooterItemView = {
        let footerItemView = FooterItemView()
        footerItemView.translatesAutoresizingMaskIntoConstraints = false
        return footerItemView
    }()

    // MARK: - Public
    struct Model {
        let postId: String
        let text: String
        let userFullName: String?
        let userPhotoURL: URL?
        let date: Date?
        let countLikes: Int
        let countReposts: Int
        let countComments: Int
        let likeEnabled: Bool
    }

    var didTapLike: ((String?, Bool?) -> Void)?

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

        containerView.addSubview(headerItemView)
        NSLayoutConstraint.activate([
            headerItemView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            headerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            headerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        containerView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: headerItemView.bottomAnchor, constant: 16.0),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        containerView.addSubview(footerItemView)
        NSLayoutConstraint.activate([
            footerItemView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8.0),
            footerItemView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
            footerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            footerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        footerItemView.likeButton.addTarget(self, action: #selector(tapLikeAction), for: .touchUpInside)
    }

    @objc private func tapLikeAction() {
        didTapLike?(postId, likeEnabled)
    }

    // MARK: - Public
    func configure(with model: Model) {
        postId = model.postId
        likeEnabled = model.likeEnabled
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

}
