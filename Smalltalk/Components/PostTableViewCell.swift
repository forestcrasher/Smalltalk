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
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 15.0
        contentView.addSubview(view)
        return view
    }()

    private lazy var headerItemView: HeaderItemView = {
        let view = HeaderItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(view)
        return view
    }()

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

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.backgroundColor = .green
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin]

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])



        NSLayoutConstraint.activate([
            headerItemView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            headerItemView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20.0),
            headerItemView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20.0)
        ])

    }

    private func setupUI() {
//        contentView.backgroundColor = .green
//
//        contentView.addSubview(containerView)
//        containerView.addSubview(headerItemView)
//
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
//            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
//            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 16.0),
//            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16.0)
//        ])
//
//        NSLayoutConstraint.activate([
//            headerItemView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            headerItemView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
//            headerItemView.rightAnchor.constraint(equalTo: containerView.rightAnchor)
//        ])

//        contentView.addSubview(authorImageView)
//        contentView.addSubview(authorLabel)
//        contentView.addSubview(textView)

//        NSLayoutConstraint.activate([
//            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
//            authorImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
//            authorImageView.widthAnchor.constraint(equalToConstant: 64.0),
//            authorImageView.heightAnchor.constraint(equalToConstant: 64.0)
//        ])
//
//        NSLayoutConstraint.activate([
//            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
//            authorLabel.leftAnchor.constraint(equalTo: authorImageView.rightAnchor, constant: 16.0),
//            authorLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
//            authorLabel.heightAnchor.constraint(equalToConstant: 64.0)
//        ])
//
//        NSLayoutConstraint.activate([
//            textView.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 16.0),
//            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16.0),
//            textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16.0),
//            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
//        ])
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
