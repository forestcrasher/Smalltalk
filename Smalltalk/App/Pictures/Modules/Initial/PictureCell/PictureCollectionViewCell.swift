//
//  PictureCollectionViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 05.12.2020.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PictureCollectionViewCell: UICollectionViewCell {

    // MARK: - Public
    struct Model {
        let URL: URL?
        let authorFullName: String?
        let authorPhotoURL: URL?
    }

    func configure(with model: Model) {
        authorLabel.text = model.authorFullName
        if let downloadURL = model.URL {
            let processor = DownsamplingImageProcessor(size: imageView.superview?.bounds.size ?? CGSize(width: 0, height: 0))
            let resourse = ImageResource(downloadURL: downloadURL, cacheKey: downloadURL.absoluteString)
            imageView.kf.setImage(with: resourse, options: [.processor(processor), .loadDiskFileSynchronously, .backgroundDecode])
        }
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
        label.font = .systemFont(ofSize: 20)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private func setupUI() {
        addSubview(authorImageView)
        addSubview(authorLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            authorImageView.topAnchor.constraint(equalTo: topAnchor),
            authorImageView.leftAnchor.constraint(equalTo: leftAnchor),
            authorImageView.widthAnchor.constraint(equalToConstant: 64.0),
            authorImageView.heightAnchor.constraint(equalToConstant: 64.0)
        ])

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: topAnchor),
            authorLabel.leftAnchor.constraint(equalTo: authorImageView.rightAnchor, constant: 16.0),
            authorLabel.rightAnchor.constraint(equalTo: rightAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 64.0)
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 16.0),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor)
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
