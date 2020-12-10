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

    // MARK: - Model
    struct Model {
        let url: URL?
        let description: String
        let date: Date
        let authorFullName: String
        let authorPhotoUrl: URL?
        let countLikes: Int
        let countReposts: Int
        let countComments: Int
    }

    var model: Model! {
        didSet {
            authorLabel.text = model.authorFullName
            if let url = model?.url {
                let resourse = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                imageView.kf.setImage(with: resourse, options: [.loadDiskFileSynchronously, .backgroundDecode])
            }
        }
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
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
        addSubview(authorLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: topAnchor),
            authorLabel.leftAnchor.constraint(equalTo: leftAnchor),
            authorLabel.rightAnchor.constraint(equalTo: rightAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor),
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
