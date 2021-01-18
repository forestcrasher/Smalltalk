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
    private var viewModel: PicturesViewModel

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if viewModel.loading.value {
            setupInternalBindings()
        }
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        collectionView.addSubview(activityIndicatorView)
        activityIndicatorView.center = collectionView.center
        return activityIndicatorView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = R.color.labelColor()
        collectionView.addSubview(refreshControl)
        return refreshControl
    }()

    private lazy var collectionView: UICollectionView = {
        let screenSizeWidth: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        let leftAndRightPaddings: CGFloat = 32.0
        let width = screenSizeWidth - leftAndRightPaddings
        let height = width * 1.29

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 16.0

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = R.color.backgroundColor()
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PictureCollectionViewCell.self))
        view.addSubview(collectionView)
        return collectionView
    }()

    private let addBarButtonItem: UIBarButtonItem = {
        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage.plus?.withTintColor(R.color.fillColor()!), for: .normal)
        addButton.setImage(UIImage.plus?.withTintColor(R.color.fillColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
        return UIBarButtonItem(customView: addButton)
    }()

    private func setupUI() {
        title = R.string.localizable.picturesTitle()
        view.backgroundColor = R.color.backgroundColor()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItems = [addBarButtonItem]

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupInternalBindings() {
        viewModel
            .setup(with: PicturesViewModel.Input(refreshDialogs: refreshControl.rx.controlEvent(.valueChanged).asSignal()))
            .disposed(by: disposeBag)

        viewModel.loading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.refreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        Observable.combineLatest(viewModel.pictures, viewModel.currentUser)
            .map { (posts, currentUser) in posts.map { ($0, currentUser) } }
            .bind(to: collectionView.rx.items(cellIdentifier: String(describing: PictureCollectionViewCell.self), cellType: PictureCollectionViewCell.self)) { _, data, cell in
                let (picture, currentUser) = data
                let model = PictureCollectionViewCell.Model(
                    URL: picture.URL,
                    userFullName: picture.author?.fullName,
                    userPhotoURL: picture.author?.photoURL,
                    date: picture.date,
                    countLikes: picture.countLikes,
                    countReposts: picture.countReposts,
                    countComments: picture.countComments,
                    likeEnabled: picture.likes.contains(currentUser?.id ?? ""))
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Init
    init(viewModel: PicturesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
