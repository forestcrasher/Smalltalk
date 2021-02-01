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

    // MARK: - Private
    private let userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = R.color.backgroundColor()
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 20.0
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

    private let geoLabel: UILabel = {
        let geoLabel = UILabel()
        geoLabel.font = .systemFont(ofSize: 12.0)
        geoLabel.textColor = R.color.secondaryLabelColor()
        geoLabel.translatesAutoresizingMaskIntoConstraints = false
        return geoLabel
    }()

    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .systemFont(ofSize: 12.0)
        dateLabel.textColor = R.color.secondaryLabelColor()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    // MARK: - Public
    var userText: String? {
        get { userLabel.text }
        set { userLabel.text = newValue }
    }

    var geoText: String? {
        get { geoLabel.text }
        set { geoLabel.text = newValue }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    private func setupUI() {
        heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        addSubview(userImageView)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 48.0),
            userImageView.heightAnchor.constraint(equalToConstant: 48.0)
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

        containerInfoView.addSubview(geoLabel)
        NSLayoutConstraint.activate([
            geoLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor),
            geoLabel.bottomAnchor.constraint(equalTo: containerInfoView.bottomAnchor),
            geoLabel.leadingAnchor.constraint(equalTo: containerInfoView.leadingAnchor),
            geoLabel.trailingAnchor.constraint(equalTo: containerInfoView.trailingAnchor)
        ])

        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerInfoView.trailingAnchor, constant: 20.0)
        ])
    }

    // MARK: - Public
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

}
