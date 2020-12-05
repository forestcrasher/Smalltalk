//
//  PostTableViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 03.12.2020.
//

import UIKit
import RxSwift
import RxCocoa

class PostTableViewCell: UITableViewCell {

    // MARK: - Static
    static let reuseIdentifier = "PostTableViewCell"

    // MARK: - ViewModel
    var viewModel: PostTableViewCellViewModel! {
        didSet {
            viewModel
                .setup(with: PostTableViewCellViewModel.Input())
                .disposed(by: disposeBag)

            viewModel
                .post
                .subscribe(onNext: { [unowned self] post in
                    self.textLabel?.text = post.text
                })
                .disposed(by: disposeBag)

            viewModel
                .author
                .subscribe(onNext: { [unowned self] author in
                    self.detailTextLabel?.text = author?.fullName
                })
                .disposed(by: disposeBag)
        }
    }

    // MARK: - Private
    let disposeBag = DisposeBag()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
