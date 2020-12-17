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
        let date: Date?
    }

    func configure(with model: Model) {
        headerItemView.userText = model.authorFullName
        headerItemView.geoText = "Test"
        headerItemView.setUserImage(with: model.authorPhotoURL)
        headerItemView.setDate(model.date)
        textView.text = model.text
    }

    // MARK: - Private
    private lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = R.color.secondaryBackgroundColor()
        containerView.layer.cornerRadius = 15.0
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

    private func setupUI() {
        backgroundColor = .clear

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8.0)
        ])

        NSLayoutConstraint.activate([
            headerItemView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0),
            headerItemView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20.0),
            headerItemView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20.0)
        ])

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: headerItemView.bottomAnchor, constant: 16.0),
            textView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20.0),
            textView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20.0),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16.0)
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
