//
//  UserCard.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 13.01.2021.
//

import UIKit

class UserCardView: UIView {

    // MARK: - Static
    private static let dateFormatter = DateFormatter()

    // MARK: - Public
    var userText: String? {
        get { userLabel.text }
        set { userLabel.text = newValue }
    }

    var messageText: String? {
        get { messageLabel.text }
        set { messageLabel.text = newValue }
    }

    enum Size {
        case small
        case large
    }

    // MARK: - Private
    private var size: Size = .small

    private lazy var userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = R.color.backgroundColor()
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = size == .small ? 20.0 : 24
        return userImageView
    }()

    private let containerInfoView: UIView = {
        let containerInfoView = UIView()
        containerInfoView.translatesAutoresizingMaskIntoConstraints = false
        return containerInfoView
    }()

    private let userLabel: UILabel = {
        let userLabel = UILabel()
        userLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
        userLabel.textColor = R.color.labelColor()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        return userLabel
    }()

    private let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.font = .systemFont(ofSize: 12.0)
        messageLabel.textColor = R.color.secondaryLabelColor()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()

    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12.0)
        dateLabel.textColor = R.color.secondaryLabelColor()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    // MARK: - Init
    convenience init(size: Size) {
        self.init()

        self.size = size
        setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    func setUserImage(with url: URL?) {
        DispatchQueue.main.async { [weak self] in
            self?.userImageView.setImage(with: url)
        }
    }

    func setDate(_ date: Date?) {
        if let date = date {
            let dateFormatter = UserCardView.dateFormatter
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateLabel.text = dateFormatter.string(from: date)
        }
    }

    // MARK: - Private
    private func setupUI() {
        let cardSize: CGFloat = size == .small ? 48.0 : 60.0

        heightAnchor.constraint(equalToConstant: cardSize).isActive = true

        addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: cardSize),
            userImageView.heightAnchor.constraint(equalToConstant: cardSize)
        ])

        addSubview(containerInfoView)
        NSLayoutConstraint.activate([
            containerInfoView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20.0),
            containerInfoView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        containerInfoView.addSubview(userLabel)
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: containerInfoView.topAnchor),
            userLabel.leadingAnchor.constraint(equalTo: containerInfoView.leadingAnchor),
            userLabel.trailingAnchor.constraint(equalTo: containerInfoView.trailingAnchor)
        ])

        containerInfoView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 4.0),
            messageLabel.bottomAnchor.constraint(equalTo: containerInfoView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: containerInfoView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: containerInfoView.trailingAnchor)
        ])

        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerInfoView.trailingAnchor, constant: 20.0)
        ])
    }

}
