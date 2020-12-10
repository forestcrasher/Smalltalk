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

    // MARK: - ViewModel
    var viewModel: PictureCollectionViewCellViewModel! {
        didSet {
            viewModel.author
                .subscribe(onNext: { [weak self] author in
                    self?.authorLabel.text = author?.fullName
                })
                .disposed(by: disposeBag)

            viewModel.authorPhotoDownloadURL
                .subscribe(onNext: { [weak self] authorPhotoDownloadURL in
                    if let downloadURL = authorPhotoDownloadURL {
                        let resourse = ImageResource(downloadURL: downloadURL, cacheKey: downloadURL.absoluteString)
                        self?.authorImageView.kf.setImage(with: resourse, options: [.loadDiskFileSynchronously, .backgroundDecode])
                    }
                })
                .disposed(by: disposeBag)

            viewModel.downloadURL
                .subscribe(onNext: { [weak self] downloadURL in
                    if let downloadURL = downloadURL {
                        let resourse = ImageResource(downloadURL: downloadURL, cacheKey: downloadURL.absoluteString)
                        self?.imageView.kf.setImage(with: resourse, options: [.loadDiskFileSynchronously, .backgroundDecode])
                    }
                })
                .disposed(by: disposeBag)
        }
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

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
        addSubview(authorImageView)
        addSubview(authorLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            authorImageView.topAnchor.constraint(equalTo: topAnchor),
            authorImageView.leftAnchor.constraint(equalTo: leftAnchor),
            authorImageView.widthAnchor.constraint(equalToConstant: 60.0),
            authorImageView.heightAnchor.constraint(equalToConstant: 60.0)
        ])

        NSLayoutConstraint.activate([
            authorLabel.topAnchor.constraint(equalTo: topAnchor),
            authorLabel.leftAnchor.constraint(equalTo: authorImageView.rightAnchor, constant: 10.0),
            authorLabel.rightAnchor.constraint(equalTo: rightAnchor),
            authorLabel.heightAnchor.constraint(equalToConstant: 60.0)
        ])

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: authorImageView.bottomAnchor, constant: 10.0),
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
