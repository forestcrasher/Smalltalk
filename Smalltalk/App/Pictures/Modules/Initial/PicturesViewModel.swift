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
    private lazy var picturesStorage = container.resolve(PicturesStorage.self, argument: container)!
    private lazy var usersStorage = container.resolve(UsersStorage.self, argument: container)!
    weak var coordinator: PicturesCoordinator?

    // MARK: - Setup
    struct Input {
        let refreshDialogs: Signal<Void>
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Public
    let pictures = BehaviorRelay<[PictureCollectionViewCell.Model]>(value: [])
    let loading = BehaviorRelay<Bool>(value: true)
    let refreshing = BehaviorRelay<Bool>(value: false)

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    func setup(with input: Input) -> Disposable {
        let driver: Driver<([Picture], User?)> = Observable
            .combineLatest(picturesStorage.getData, usersStorage.getData)
            .asDriver(onErrorJustReturn: ([], nil))

        driver
            .map { _ in false }
            .drive(loading)
            .disposed(by: disposeBag)

        driver
            .map { _ in false }
            .drive(refreshing)
            .disposed(by: disposeBag)

        driver
            .map { data -> [PictureCollectionViewCell.Model] in
                let (pictures, currentUser) = data
                return pictures.reduce(into: [], { result, picture in
                    result.append(PictureCollectionViewCell.Model(
                        URL: picture.URL,
                        userFullName: picture.author?.fullName,
                        userPhotoURL: picture.author?.photoURL,
                        date: picture.date,
                        countLikes: picture.countLikes,
                        countReposts: picture.countReposts,
                        countComments: picture.countComments,
                        likeEnabled: picture.likes.contains(currentUser?.id ?? "")
                    ))
                })
            }
            .drive(pictures)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .startWith(())
            .emit(to: picturesStorage.picturesRelay)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .startWith(())
            .emit(to: usersStorage.userRelay)
            .disposed(by: disposeBag)

        input.refreshDialogs
            .map { true }
            .emit(to: refreshing)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

}
