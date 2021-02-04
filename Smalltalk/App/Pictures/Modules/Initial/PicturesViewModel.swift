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
    let tapLikeAction = PublishRelay<(String, Bool)>()

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

        let driverUpdateLike = tapLikeAction
            .flatMap { [weak picturesStorage] (pictureId, likeEnabled) in
                return likeEnabled
                    ? (picturesStorage?.unlikePicture(by: pictureId) ?? Observable.just((pictureId, true)))
                    : (picturesStorage?.likePicture(by: pictureId) ?? Observable.just((pictureId, false)))
            }
            .asDriver(onErrorJustReturn: ("", false))

        pictures = Driver
            .combineLatest(
                driver,
                driverUpdateLike.startWith(("", false))
            )
            .scan(([], nil)) { prev, data -> ([Picture], User?) in
                let (oldPictures, oldCurrentUser) = prev
                let ((newPictures, newCurrentUser), (pictureId, likeEnabled)) = data
                let pictures = newPictures.isEmpty || newPictures == oldPictures ? oldPictures : newPictures
                let currentUser = newCurrentUser == nil || newCurrentUser == oldCurrentUser ? oldCurrentUser : newCurrentUser
                if pictureId != "" {
                    let nextPictures = pictures.map { picture -> Picture in
                        var newPicture = picture
                        if newPicture.id == pictureId {
                            if likeEnabled {
                                if let id = currentUser?.id, !newPicture.likes.contains(id) {
                                    newPicture.likes.append(id)
                                }
                            } else {
                                if let id = currentUser?.id, let index = newPicture.likes.firstIndex(of: id) {
                                    newPicture.likes.remove(at: index)
                                }
                            }
                        }
                        return newPicture
                    }
                    return (nextPictures, currentUser)
                } else {
                    return (pictures, currentUser)
                }
            }
            .map { data -> [PictureCollectionViewCell.Model] in
                let (pictures, currentUser) = data
                return pictures.reduce(into: [], { result, picture in
                    result.append(PictureCollectionViewCell.Model(
                        pictureId: picture.id,
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
