//
//  ProfileViewController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ProfileViewController: UIViewController {

    // MARK: - ViewModel
    private var viewModel: ProfileViewModel

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupInternalBindings()
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = R.string.localizable.profileTitle()

        view.addSubview(photoImageView)
        view.addSubview(fullNameLabel)

        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 256.0),
            photoImageView.widthAnchor.constraint(equalToConstant: 256.0)
        ])

        NSLayoutConstraint.activate([
            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 32.0)
        ])
    }

    private func setupInternalBindings() {
        viewModel
            .setup(with: ProfileViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .currentUser
            .subscribe(onNext: { [weak self] currentUser in
                self?.fullNameLabel.text = currentUser?.fullName
                if let downloadURL = currentUser?.photoURL {
                    let processor = DownsamplingImageProcessor(size: self?.photoImageView.superview?.bounds.size ?? CGSize(width: 0, height: 0))
                    let resourse = ImageResource(downloadURL: downloadURL, cacheKey: downloadURL.absoluteString)
                    self?.photoImageView.kf.setImage(with: resourse, options: [.processor(processor), .loadDiskFileSynchronously, .backgroundDecode])
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
