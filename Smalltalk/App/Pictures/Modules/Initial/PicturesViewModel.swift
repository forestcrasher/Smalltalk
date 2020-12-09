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
    private var usersStorage: UsersStorage = AppDelegate.container.resolve(UsersStorage.self)!
    private var filesStorage: FilesStorage = AppDelegate.container.resolve(FilesStorage.self)!
    weak var coordinator: PicturesCoordinator!

    // MARK: - Setup
    struct Input {}

    func setup(with input: Input) -> Disposable {
        picturesStorage
            .fetchPictures()
            .flatMap { [weak self] pictures -> Observable<[(Picture, User?)]> in
                let data: [Observable<(Picture, User?)>] = pictures.reduce(into: []) { result, picture in
                    let item = self?.usersStorage.fetchUser(by: picture.authorRef).flatMap { Observable.just((picture, $0)) } ?? Observable.just((picture, nil))
                    result.append(item)
                }
                return Observable<(Picture, User?)>.combineLatest(data)
            }
            .flatMap { [weak self] prevData -> Observable<[(Picture, User?, URL?)]> in
                let data: [Observable<(Picture, User?, URL?)>] = prevData.reduce(into: []) { result, prevItem in
                    let (picture, author) = prevItem
                    let item = self?.filesStorage.fetchUrl(by: picture.url).flatMap { Observable.just((picture, author, $0)) } ?? Observable.just((picture, author, nil))
                    result.append(item)
                }
                return Observable<(Picture, User?, URL?)>.combineLatest(data)
            }
            .flatMap { [weak self] prevData -> Observable<[(Picture, User?, URL?, URL?)]> in
                let data: [Observable<(Picture, User?, URL?, URL?)>] = prevData.reduce(into: []) { result, prevItem in
                    let (picture, author, url) = prevItem
                    let item = self?.filesStorage.fetchUrl(by: author?.photoUrl ?? "").flatMap { Observable.just((picture, author, url, $0)) } ?? Observable.just((picture, author, url, nil))
                    result.append(item)
                }
                return Observable<(Picture, User?, URL?, URL?)>.combineLatest(data)
            }
            .map { pictures -> [PictureCollectionViewCell.Model] in
                var res = [PictureCollectionViewCell.Model]()
                for (picture, author, url, authorPhotoUrl) in pictures {
                    res.append(PictureCollectionViewCell.Model(
                        url: url,
                        description: picture.description,
                        date: picture.date,
                        authorFullName: author?.fullName ?? "",
                        authorPhotoUrl: authorPhotoUrl,
                        countLikes: picture.countLikes,
                        countReposts: picture.countReposts,
                        countComments: picture.countComments
                    ))
                }
                return res
            }
            .bind(to: pictures)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public
    let pictures = BehaviorRelay<[PictureCollectionViewCell.Model]>(value: [])

    // MARK: - Private
    private let disposeBag = DisposeBag()

}
