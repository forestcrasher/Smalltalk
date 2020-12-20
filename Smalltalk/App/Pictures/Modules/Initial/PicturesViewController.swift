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
        setupInternalBindings()
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private lazy var collectionView: UICollectionView = {
        let screenSizeWidth: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        let leftAndRightPaddings: CGFloat = 32.0
        let numberOfItemsPerRow: CGFloat = 1.0
        let side = (screenSizeWidth - leftAndRightPaddings) / numberOfItemsPerRow

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        layout.itemSize = CGSize(width: side, height: side)
        layout.minimumLineSpacing = 32.0

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = R.color.backgroundColor()
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PictureCollectionViewCell.self))
        view.addSubview(collectionView)
        return collectionView
    }()

    private func setupUI() {
        title = R.string.localizable.picturesTitle()
        view.backgroundColor = R.color.backgroundColor()

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupInternalBindings() {
        viewModel
            .setup(with: PicturesViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .pictures
            .bind(to: collectionView.rx.items(cellIdentifier: String(describing: PictureCollectionViewCell.self), cellType: PictureCollectionViewCell.self)) { _, picture, cell in
                cell.configure(with: PictureCollectionViewCell.Model(URL: picture.URL, authorFullName: picture.author?.fullName, authorPhotoURL: picture.author?.photoURL))
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
