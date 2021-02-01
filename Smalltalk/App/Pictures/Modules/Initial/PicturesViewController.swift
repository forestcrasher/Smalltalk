//
//  PicturesViewController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import RxSwift
import RxCocoa

class PicturesViewController: UIViewController {

    // MARK: - ViewModel
    private let viewModel: PicturesViewModel

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        return activityIndicatorView
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = R.color.labelColor()
        return refreshControl
    }()

    private lazy var collectionView: UICollectionView = {
        let screenSizeWidth: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        let leftAndRightPaddings: CGFloat = 32.0
        let width = screenSizeWidth - leftAndRightPaddings
        let height = width * 1.29

        let margin: CGFloat = 16.0
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = margin

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = R.color.backgroundColor()
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PictureCollectionViewCell.self))
        return collectionView
    }()

    private let addBarButtonItem: UIBarButtonItem = {
        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage.plus?.withTintColor(R.color.fillColor()!), for: .normal)
        addButton.setImage(UIImage.plus?.withTintColor(R.color.fillColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
        return UIBarButtonItem(customView: addButton)
    }()

    // MARK: - Init
    init(viewModel: PicturesViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupInternalBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.loadAction.accept(())
    }

    // MARK: - Private
    private func setupUI() {
        title = R.string.localizable.picturesTitle()
        view.backgroundColor = R.color.backgroundColor()
        navigationItem.rightBarButtonItems = [addBarButtonItem]

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        collectionView.addSubview(refreshControl)

        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupInternalBindings() {
        viewModel.loading
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.refreshing
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.pictures
            .drive(collectionView.rx.items(cellIdentifier: String(describing: PictureCollectionViewCell.self), cellType: PictureCollectionViewCell.self)) { _, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)

        refreshControl.rx
            .controlEvent(.valueChanged)
            .asSignal()
            .emit(to: viewModel.refreshAction)
            .disposed(by: disposeBag)
    }

}
