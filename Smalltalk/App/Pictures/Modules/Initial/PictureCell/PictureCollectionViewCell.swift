//
//  PictureCollectionViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 05.12.2020.
//

import UIKit
import RxSwift
import RxCocoa

class PictureCollectionViewCell: UICollectionViewCell {

    // MARK: - Static
    static let reuseIdentifier = "PictureCollectionViewCell"

    // MARK: - ViewModel
    var viewModel: PictureCollectionViewCellViewModel! {
        didSet {
            if oldValue == nil {
                setupInternalBindings()
            }
        }
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }()

    private func setupUI() {
        addSubview(authorLabel)
        addSubview(imageView)

        authorLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        authorLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 40.0).isActive = true

        imageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }

    private func setupInternalBindings() {
        viewModel
            .setup(with: PictureCollectionViewCellViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .author
            .subscribe(onNext: { [unowned self] author in
                self.authorLabel.text = author?.fullName
            })
            .disposed(by: disposeBag)

        viewModel
            .image
            .subscribe(onNext: { [unowned self] image in
                if let data = image {
                    self.imageView.image = UIImage(data: data)
                }
            })
            .disposed(by: disposeBag)
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
