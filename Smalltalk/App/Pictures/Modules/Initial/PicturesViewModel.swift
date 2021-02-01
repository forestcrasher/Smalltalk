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

    // MARK: - Dependencies
    private let picturesStorage: PicturesStorage
    private let usersStorage: UsersStorage
    weak var coordinator: PicturesCoordinator?

    // MARK: - Public
    let loadAction = PublishRelay<Void>()
    let refreshAction = PublishRelay<Void>()

    let pictures: Driver<[PictureCollectionViewCell.Model]>
    let loading: Driver<Bool>
    let refreshing: Driver<Bool>

    // MARK: - Init
    init(container: Container) {
        picturesStorage = container.resolve(PicturesStorage.self, argument: container)!
        usersStorage = container.resolve(UsersStorage.self, argument: container)!

        let driver: Driver<([Picture], User?)> = Observable
            .merge(loadAction.take(1).asObservable(), refreshAction.asObservable())
            .flatMap { [weak picturesStorage, weak usersStorage] in
                return Observable
                    .combineLatest((picturesStorage?.fetchPictures() ?? Observable.just([])), (usersStorage?.fetchCurrentUser() ?? Observable.just(nil)))
            }
            .asDriver(onErrorJustReturn: ([], nil))

        loading = Driver
            .merge(loadAction.take(1).map { _ in true }.asDriver(onErrorJustReturn: false), driver.map { _ in false })

        refreshing = Driver
            .merge(refreshAction.map { _ in true }.asDriver(onErrorJustReturn: false), driver.map { _ in false })

        pictures = driver
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
    }

}
