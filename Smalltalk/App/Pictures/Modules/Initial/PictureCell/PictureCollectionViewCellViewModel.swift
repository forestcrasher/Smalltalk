//
//  PictureCollectionViewCellViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 10.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

class PictureCollectionViewCellViewModel {

    // MARK: - Dependencies
    private var usersStorage: UsersStorage = AppDelegate.container.resolve(UsersStorage.self)!
    private var filesStorage: FilesStorage = AppDelegate.container.resolve(FilesStorage.self)!

    // MARK: - Public
    let picture: BehaviorRelay<Picture>
    let downloadURL = BehaviorRelay<URL?>(value: nil)
    let author = BehaviorRelay<User?>(value: nil)
    let authorPhotoDownloadURL = BehaviorRelay<URL?>(value: nil)

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(picture: Picture) {
        self.picture = BehaviorRelay(value: picture)

        filesStorage
            .fetchDownloadURL(by: picture.path)
            .bind(to: downloadURL)
            .disposed(by: disposeBag)

        usersStorage
            .fetchUser(by: picture.authorRef)
            .flatMap { [weak self] author in
                self?.filesStorage.fetchDownloadURL(by: author.photoPath).map { (author, $0) } ?? Observable.just((author, nil))
            }
            .subscribe(onNext: { [weak self] (author, authorPhotoDownloadURL) in
                self?.author.accept(author)
                self?.authorPhotoDownloadURL.accept(authorPhotoDownloadURL)
            })
            .disposed(by: disposeBag)
    }
}
