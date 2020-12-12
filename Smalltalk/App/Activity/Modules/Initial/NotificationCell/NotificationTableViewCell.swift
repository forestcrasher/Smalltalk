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
    }

    func configure(with model: Model) {
        dispatcherLabel.text = model.dispatcherFullName
        messageLabel.text = model.messageText
        if let downloadURL = model.dispatcherPhotoURL {
            let processor = DownsamplingImageProcessor(size: dispatcherImageView.superview?.bounds.size ?? CGSize(width: 0, height: 0))
            let resourse = ImageResource(downloadURL: downloadURL, cacheKey: downloadURL.absoluteString)
            dispatcherImageView.kf.setImage(with: resourse, options: [.processor(processor), .loadDiskFileSynchronously, .backgroundDecode])
        }
    }

    // MARK: - Private
    private let dispatcherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let dispatcherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupUI() {
        contentView.addSubview(dispatcherImageView)
        contentView.addSubview(dispatcherLabel)
        contentView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            dispatcherImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            dispatcherImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            dispatcherImageView.widthAnchor.constraint(equalToConstant: 64.0),
            dispatcherImageView.heightAnchor.constraint(equalToConstant: 64.0),
            dispatcherImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])

        NSLayoutConstraint.activate([
            dispatcherLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            dispatcherLabel.leftAnchor.constraint(equalTo: dispatcherImageView.rightAnchor, constant: 16.0),
            dispatcherLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            dispatcherLabel.heightAnchor.constraint(equalToConstant: 32.0)
        ])

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: dispatcherLabel.bottomAnchor),
            messageLabel.leftAnchor.constraint(equalTo: dispatcherImageView.rightAnchor, constant: 16.0),
            messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            messageLabel.heightAnchor.constraint(equalToConstant: 32.0)
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
