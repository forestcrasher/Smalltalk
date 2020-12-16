//
//  DialogTableViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 07.12.2020.
//

import UIKit
import Kingfisher

class DialogTableViewCell: UITableViewCell {

    // MARK: - Public
    struct Model {
        let recipientFullName: String?
        let recipientPhotoURL: URL?
        let lastMessageText: String?
    }

    func configure(with model: Model) {
        recipientLabel.text = model.recipientFullName
        lastMessageLabel.text = model.lastMessageText
        if let downloadURL = model.recipientPhotoURL {
            let processor = DownsamplingImageProcessor(size: recipientImageView.superview?.bounds.size ?? CGSize(width: 0, height: 0))
            let resourse = ImageResource(downloadURL: downloadURL, cacheKey: downloadURL.absoluteString)
            recipientImageView.kf.setImage(with: resourse, options: [.processor(processor), .loadDiskFileSynchronously, .backgroundDecode])
        }
    }

    // MARK: - Private
    private let recipientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let recipientLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupUI() {
        contentView.addSubview(recipientImageView)
        contentView.addSubview(recipientLabel)
        contentView.addSubview(lastMessageLabel)

        NSLayoutConstraint.activate([
            recipientImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            recipientImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            recipientImageView.widthAnchor.constraint(equalToConstant: 64.0),
            recipientImageView.heightAnchor.constraint(equalToConstant: 64.0),
            recipientImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])

        NSLayoutConstraint.activate([
            recipientLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            recipientLabel.leftAnchor.constraint(equalTo: recipientImageView.rightAnchor, constant: 16.0),
            recipientLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            recipientLabel.heightAnchor.constraint(equalToConstant: 32.0)
        ])

        NSLayoutConstraint.activate([
            lastMessageLabel.topAnchor.constraint(equalTo: recipientLabel.bottomAnchor),
            lastMessageLabel.leftAnchor.constraint(equalTo: recipientImageView.rightAnchor, constant: 16.0),
            lastMessageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            lastMessageLabel.heightAnchor.constraint(equalToConstant: 32.0)
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
