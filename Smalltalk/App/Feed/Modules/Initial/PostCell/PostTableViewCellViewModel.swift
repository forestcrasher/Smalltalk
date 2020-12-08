//
//  PostTableViewCellViewModel.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 05.12.2020.
//

import Foundation
import RxSwift
import RxCocoa

class PostTableViewCellViewModel {

    // MARK: - Dependencies
    private var postsStorage: PostsStorage = AppDelegate.container.resolve(PostsStorage.self)!

    // MARK: - Setup
    struct Input {}

    func setup(with input: Input) -> Disposable {
        postsStorage
            .fetchAuthor(by: post.value.authorRef)
            .bind(to: author)
            .disposed(by: disposeBag)

        return Disposables.create()
    }

    // MARK: - Public

    let post: BehaviorRelay<Post>
    let author = BehaviorRelay<User?>(value: nil)

    // MARK: - Private
    private let disposeBag = DisposeBag()

    // MARK: - Init
    init(post: Post) {
        self.post = BehaviorRelay(value: post)
    }

}
