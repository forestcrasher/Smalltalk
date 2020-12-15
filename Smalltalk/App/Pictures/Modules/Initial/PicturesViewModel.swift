//
//  PicturesViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 05.12.2020.
//

import Foundation
import RxSwift
import RxCocoa
import Swinject

class PicturesViewModel {

    // MARK: - Container
    private let container: Container

    // MARK: - Dependencies
    private lazy var picturesStorage: PicturesStorage = container.resolve(PicturesStorage.self, argument: container)!
    weak var coordinator: PicturesCoordinator?

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

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

}
