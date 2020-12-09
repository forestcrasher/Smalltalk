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
