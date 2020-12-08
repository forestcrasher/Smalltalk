//
//  MessagesViewController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import RxSwift
import RxCocoa

class MessagesViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: MessagesViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupInternalBindings()
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 54.0
        tableView.register(DialogTableViewCell.self, forCellReuseIdentifier: String(describing: DialogTableViewCell.self))
        return tableView
    }()

    private var cellViewModels: BehaviorRelay<[DialogTableViewCellViewModel]> = BehaviorRelay(value: [])

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = "Messages"

        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func setupInternalBindings() {
        viewModel
            .setup(with: MessagesViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .dialogs
            .subscribe(onNext: { dialogs in
                let viewModels = dialogs.reduce(into: []) { result, dialogs in
                    result.append(AppDelegate.container.resolve(DialogTableViewCellViewModel.self, argument: dialogs)!)
                }
                self.cellViewModels.accept(viewModels)
            })
            .disposed(by: disposeBag)

        cellViewModels
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: DialogTableViewCell.self), cellType: DialogTableViewCell.self)) { _, dialogViewModel, cell in
                cell.viewModel = dialogViewModel
            }
            .disposed(by: disposeBag)
    }

}
