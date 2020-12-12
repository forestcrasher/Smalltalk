//
//  PicturesViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 05.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

class PicturesViewModel {

    // MARK: - Dependencies
    private var picturesStorage: PicturesStorage = AppDelegate.container.resolve(PicturesStorage.self)!
    weak var coordinator: PicturesCoordinator!

    // MARK: - Setup
    struct Input {}

    func setup(with input: Input) -> Disposable {
        picturesStorage
            .fetchPictures()
            .bind(to: pictures)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let pictures = BehaviorRelay<[Picture]>(value: [])

    // MARK: - Private
    private let disposeBag = DisposeBag()

}
