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
    var viewModel: PicturesViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        viewModel
            .setup(with: PicturesViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .pictures
            .bind(to: collectionView.rx.items(cellIdentifier: PictureCollectionViewCell.reuseIdentifier, cellType: PictureCollectionViewCell.self)) { _, picture, cell in
                if cell.viewModel == nil {
                    cell.viewModel = AppDelegate.container.resolve(PictureCollectionViewCellViewModel.self, argument: picture)
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private lazy var collectionView: UICollectionView = {
        let screenSizeWidth: CGFloat = view.safeAreaLayoutGuide.layoutFrame.width
        let leftAndRightPaddings: CGFloat = 20.0
        let numberOfItemsPerRow: CGFloat = 1.0
        let side = (screenSizeWidth - leftAndRightPaddings) / numberOfItemsPerRow

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        collectionViewLayout.itemSize = CGSize(width: side, height: side)

        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private let disposeBag = DisposeBag()

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = "Pictures"

        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: PictureCollectionViewCell.reuseIdentifier)
    }

}
