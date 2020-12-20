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
        set { userLabel.text = newValue }
    }

    var geoText: String? {
        get { geoLabel.text }
        set { geoLabel.text = newValue }
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
        let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = R.color.backgroundColor()
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 20.0
        addSubview(userImageView)
        return userImageView
    }()

    private lazy var containerInfoView: UIView = {
        let containerInfoView = UIView()
        containerInfoView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerInfoView)
        return containerInfoView
    }()

    private lazy var userLabel: UILabel = {
        let userLabel = UILabel()
        userLabel.font = .systemFont(ofSize: 16.0, weight: .semibold)
        userLabel.textColor = R.color.labelColor()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        containerInfoView.addSubview(userLabel)
        return userLabel
    }()

    private lazy var geoLabel: UILabel = {
        let geoLabel = UILabel()
        geoLabel.font = .systemFont(ofSize: 12.0)
        geoLabel.textColor = R.color.secondaryLabelColor()
        geoLabel.translatesAutoresizingMaskIntoConstraints = false
        containerInfoView.addSubview(geoLabel)
        return geoLabel
    }()

    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12.0)
        dateLabel.textColor = R.color.secondaryLabelColor()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        return dateLabel
    }()

    private func setupUI() {
        heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 48.0),
            userImageView.heightAnchor.constraint(equalToConstant: 48.0)
        ])

        NSLayoutConstraint.activate([
            containerInfoView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 20.0),
            containerInfoView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: containerInfoView.topAnchor),
            userLabel.leadingAnchor.constraint(equalTo: containerInfoView.leadingAnchor),
            userLabel.trailingAnchor.constraint(equalTo: containerInfoView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            geoLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor),
            geoLabel.bottomAnchor.constraint(equalTo: containerInfoView.bottomAnchor),
            geoLabel.leadingAnchor.constraint(equalTo: containerInfoView.leadingAnchor),
            geoLabel.trailingAnchor.constraint(equalTo: containerInfoView.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerInfoView.trailingAnchor, constant: 20.0)
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
