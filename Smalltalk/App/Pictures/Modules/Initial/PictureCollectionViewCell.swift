//
//  PictureCollectionViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 05.12.2020.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PictureCollectionViewCell: UICollectionViewCell {

    // MARK: - Public
    struct Model {
        let pictureId: String
        let URL: URL?
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
    private var pictureId: String?
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

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = R.color.backgroundColor()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let footerItemView: FooterItemView = {
        let footerItemView = FooterItemView()
        footerItemView.translatesAutoresizingMaskIntoConstraints = false
        return footerItemView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func configure(with model: Model) {
        pictureId = model.pictureId
        likeEnabled = model.likeEnabled

        DispatchQueue.main.async { [weak self] in
            self?.imageView.setImage(with: model.URL)
        }

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
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        containerView.addSubview(headerItemView)
        NSLayoutConstraint.activate([
            headerItemView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            headerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            headerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        containerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: headerItemView.bottomAnchor, constant: 16.0),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        containerView.addSubview(footerItemView)
        NSLayoutConstraint.activate([
            footerItemView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0),
            footerItemView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
            footerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            footerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        footerItemView.likeButton.addTarget(self, action: #selector(tapLikeAction), for: .touchUpInside)
    }

    @objc private func tapLikeAction() {
        didTapLike?(pictureId, likeEnabled)
    }

}
