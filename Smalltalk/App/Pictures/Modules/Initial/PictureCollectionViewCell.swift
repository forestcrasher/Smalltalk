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
        let URL: URL?
        let userFullName: String?
        let userPhotoURL: URL?
        let date: Date?
        let countLikes: Int
        let countReposts: Int
        let countComments: Int
        let likeEnabled: Bool
    }

    func configure(with model: Model) {
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

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = R.color.backgroundColor()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        containerView.addSubview(imageView)
        return imageView
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
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            headerItemView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            headerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            headerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: headerItemView.bottomAnchor, constant: 16.0),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])

        NSLayoutConstraint.activate([
            footerItemView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0),
            footerItemView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8.0),
            footerItemView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20.0),
            footerItemView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20.0)
        ])
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
