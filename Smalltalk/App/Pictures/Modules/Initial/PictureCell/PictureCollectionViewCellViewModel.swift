//
//  PictureCollectionViewCellViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 05.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

class PictureCollectionViewCellViewModel {

    // MARK: - Dependencies
    private var picturesStorage: PicturesStorage = AppDelegate.container.resolve(PicturesStorage.self)!

    // MARK: - Setup
    struct Input {}

    func setup(with input: Input) -> Disposable {
        picturesStorage
            .fetchAuthor(by: picture.value.authorRef)
            .bind(to: author)
            .disposed(by: disposeBag)

        picturesStorage
            .downloadImage(url: picture.value.url)
            .bind(to: image)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public

    let picture: BehaviorRelay<Picture>
    let author = BehaviorRelay<User?>(value: nil)
    let image = BehaviorRelay<Data?>(value: nil)

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(picture: Picture) {
        self.picture = BehaviorRelay(value: picture)
    }

}
