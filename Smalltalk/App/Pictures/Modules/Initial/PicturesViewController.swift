//
//  PicturesViewController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PicturesViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: PicturesViewModel!

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
        let leftAndRightPaddings: CGFloat = 40.0
        let numberOfItemsPerRow: CGFloat = 1.0
        let side = (screenSizeWidth - leftAndRightPaddings) / numberOfItemsPerRow

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        layout.itemSize = CGSize(width: side, height: side)
        layout.minimumLineSpacing = 30.0

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PictureCollectionViewCell.self))
        return collectionView
    }()

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = "Pictures"

        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func setupInternalBindings() {
        viewModel
            .setup(with: PicturesViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .pictureCellViewModels
            .bind(to: collectionView.rx.items(cellIdentifier: String(describing: PictureCollectionViewCell.self), cellType: PictureCollectionViewCell.self)) { _, viewModel, cell in
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
    }

}
