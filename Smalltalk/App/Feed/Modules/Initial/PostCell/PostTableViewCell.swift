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
        let authorFullName: String?
        let authorPhotoURL: URL?
    }

    func configure(with model: Model) {
        textView.text = model.text
        authorLabel.text = model.authorFullName
        if let downloadURL = model.authorPhotoURL {
            let processor = DownsamplingImageProcessor(size: authorImageView.superview?.bounds.size ?? CGSize(width: 0, height: 0))
            let resourse = ImageResource(downloadURL: downloadURL, cacheKey: downloadURL.absoluteString)
            authorImageView.kf.setImage(with: resourse, options: [.processor(processor), .loadDiskFileSynchronously, .backgroundDecode])
        }
    }

    // MARK: - Private
    private let authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16.0)
        textView.textColor = .darkGray
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private func setupUI() {
        contentView.addSubview(authorImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(textView)

        NSLayoutConstraint.activate([
            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            authorImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            authorImageView.widthAnchor.constraint(equalToConstant: 64.0),
            authorImageView.heightAnchor.constraint(equalToConstant: 64.0)
        ])

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            authorLabel.leftAnchor.constraint(equalTo: authorImageView.rightAnchor, constant: 16.0),
            authorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            authorLabel.heightAnchor.constraint(equalToConstant: 64.0)
        ])

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 16.0),
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
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
