//
//  HeaderItemView.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 15.12.2020.
//

import UIKit

class HeaderItemView: UIView {

    // MARK: - Private
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        addSubview(imageView)
        return imageView
    }()

    private lazy var userLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.text = "Peter Hardy"
        label.backgroundColor = .blue
        return label
    }()

    private lazy var geoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.text = "New York New York New York"
        label.backgroundColor = .brown
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.text = "7 min ago 7 min ago"
        label.backgroundColor = .cyan
        return label
    }()

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .lightGray
        heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: topAnchor),
            userImageView.leftAnchor.constraint(equalTo: leftAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 48.0),
            userImageView.heightAnchor.constraint(equalToConstant: 48.0)
        ])

        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: topAnchor, constant: 7.0),
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

    // MARK: - Init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}
