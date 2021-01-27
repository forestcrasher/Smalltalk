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

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private lazy var headerContainerView: UIView = {
        let headerContainerView = UIView()
        headerContainerView.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.backgroundColor = R.color.secondaryBackgroundColor()
        view.addSubview(headerContainerView)
        return headerContainerView
    }()

    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.backgroundColor = R.color.backgroundColor()
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 60.0
        photoImageView.layer.masksToBounds = true
        headerContainerView.addSubview(photoImageView)
        return photoImageView
    }()

    private lazy var fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.font = .systemFont(ofSize: 34, weight: .bold)
        fullNameLabel.textColor = R.color.labelColor()
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainerView.addSubview(fullNameLabel)
        return fullNameLabel
    }()

    private let settingsBarButtonItem: UIBarButtonItem = {
        let settingsButton = UIButton(type: .system)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setImage(UIImage.gear?.withTintColor(R.color.fillColor()!), for: .normal)
        settingsButton.setImage(UIImage.gear?.withTintColor(R.color.fillColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
        return UIBarButtonItem(customView: settingsButton)
    }()

    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    private func setupUI() {
        view.backgroundColor = R.color.backgroundColor()
        navigationItem.rightBarButtonItems = [settingsBarButtonItem]

        NSLayoutConstraint.activate([
            headerContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainerView.heightAnchor.constraint(equalToConstant: 304.0)
        ])

        NSLayoutConstraint.activate([
            photoImageView.centerXAnchor.constraint(equalTo: headerContainerView.centerXAnchor),
            photoImageView.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: 16.0),
            photoImageView.heightAnchor.constraint(equalToConstant: 144.0),
            photoImageView.widthAnchor.constraint(equalToConstant: 144.0)
        ])

        NSLayoutConstraint.activate([
            fullNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 16.0)
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupInternalBindings()
    }
}
