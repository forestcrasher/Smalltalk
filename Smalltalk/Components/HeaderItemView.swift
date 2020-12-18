//
//  HeaderItemView.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 15.12.2020.
//

import UIKit

class HeaderItemView: UIView {

    // MARK: - Static
    private static let dateFormatter = DateFormatter()

    // MARK: - Public
    var userText: String? {
        get { userLabel.text }
        set {
            userLabel.text = newValue
            setNeedsUpdateConstraints()
        }
    }

    var geoText: String? {
        get { geoLabel.text }
        set {
            geoLabel.text = newValue
            setNeedsUpdateConstraints()
        }
    }

    func setUserImage(with url: URL?) {
        DispatchQueue.main.async { [weak self] in
            self?.userImageView.setImage(with: url)
        }
    }

    func setDate(_ date: Date?) {
        if let date = date {
            let dateFormatter = HeaderItemView.dateFormatter
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateLabel.text = dateFormatter.string(from: date)
        }
    }

    // MARK: - Private
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = R.color.backgroundColor()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20.0
        addSubview(imageView)
        return imageView
    }()

    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = R.color.labelColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    private lazy var geoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = R.color.secondaryLabelColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = R.color.secondaryLabelColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()

    private func setupUI() {
        heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor),
            userImageView.leftAnchor.constraint(equalTo: leftAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 48.0),
            userImageView.heightAnchor.constraint(equalToConstant: 48.0)
        ])

        NSLayoutConstraint.activate([
            userLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 20.0),
            userLabel.widthAnchor.constraint(lessThanOrEqualTo: geoLabel.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            geoLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor),
            geoLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 20.0),
            geoLabel.widthAnchor.constraint(lessThanOrEqualTo: userLabel.widthAnchor)
        ])

        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.rightAnchor.constraint(equalTo: rightAnchor),
            dateLabel.leftAnchor.constraint(greaterThanOrEqualTo: userLabel.rightAnchor, constant: 20.0)
        ])
    }

    private lazy var userLabelTopAnchorConstraint = userLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14.0)

    // MARK: - Lifecycle
    override func updateConstraints() {
        super.updateConstraints()

        userLabelTopAnchorConstraint.constant = (geoLabel.text?.isEmpty ?? true) ? 14.0 : 7.0
        userLabelTopAnchorConstraint.isActive = true
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
