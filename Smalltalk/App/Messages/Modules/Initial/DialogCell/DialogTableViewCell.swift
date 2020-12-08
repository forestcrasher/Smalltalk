//
//  DialogTableViewCell.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 07.12.2020.
//

import UIKit
import RxSwift
import RxCocoa

class DialogTableViewCell: UITableViewCell {

    // MARK: - Dependencies
    private var filesStorage: FilesStorage = AppDelegate.container.resolve(FilesStorage.self)!

    // MARK: - ViewModel
    var viewModel: DialogTableViewCellViewModel! {
        didSet {
            setupInternalBindings()
        }
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private func setupInternalBindings() {
        viewModel
            .participant
            .flatMap { [unowned self] participant -> Observable<(User?, Data?)> in
                guard let photoUrl = participant?.photoUrl else {
                    return Observable.just((participant, nil))
                }
                return self.filesStorage.downloadImage(url: photoUrl).map { image in (participant, image) }
            }
            .subscribe(onNext: { [unowned self] (participant, image) in
                self.textLabel?.text = participant?.fullName
                if let data = image {
                    self.imageView?.image = UIImage(data: data)
                }
            })
            .disposed(by: disposeBag)

        viewModel
            .message
            .subscribe(onNext: { [unowned self] message in
                self.detailTextLabel?.text = message?.text
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
