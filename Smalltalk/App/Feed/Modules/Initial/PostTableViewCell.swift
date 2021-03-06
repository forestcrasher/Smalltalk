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

    private let textContentLabel: UILabel = {
        let textContentLabel = UILabel()
        textContentLabel.font = .systemFont(ofSize: 16.0)
        textContentLabel.textColor = R.color.labelColor()
        textContentLabel.numberOfLines = 0
        textContentLabel.sizeToFit()
        textContentLabel.translatesAutoresizingMaskIntoConstraints = false
        return textContentLabel
    }()

    private let footerItemView: FooterItemView = {
        let footerItemView = FooterItemView()
        footerItemView.translatesAutoresizingMaskIntoConstraints = false
        return footerItemView
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
        postId = model.postId
        likeEnabled = model.likeEnabled
        textContentLabel.text = model.text
        textContentLabel.font = .systemFont(ofSize: (textContentLabel.text?.count ?? 0) > 150 ? 16.0 : 24.0)
        headerItemView.userText = model.userFullName
        headerItemView.setUserImage(with: model.userPhotoURL)
        headerItemView.setDate(model.date)
        footerItemView.countLikes = model.countLikes
        footerItemView.countReposts = model.countReposts
        footerItemView.countComments = model.countComments
        footerItemView.likeEnabled = model.likeEnabled
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

        containerView.addSubview(textContentLabel)
        NSLayoutConstraint.activate([
            textContentLabel.topAnchor.constraint(equalTo: headerItemView.bottomAnchor, constant: 16.0),
            textContentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            textContentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        containerView.addSubview(footerItemView)
        NSLayoutConstraint.activate([
            footerItemView.topAnchor.constraint(equalTo: textContentLabel.bottomAnchor, constant: 8.0),
            footerItemView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
            footerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            footerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        footerItemView.likeButton.addTarget(self, action: #selector(tapLikeAction), for: .touchUpInside)
    }

    @objc private func tapLikeAction() {
        didTapLike?(postId, likeEnabled)
    }

}
