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
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 64.0 + 32.0
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(DialogTableViewCell.self, forCellReuseIdentifier: String(describing: DialogTableViewCell.self))
        return tableView
    }()

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = "Messages"

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func setupInternalBindings() {
        viewModel
            .setup(with: MessagesViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .dialogs
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: DialogTableViewCell.self), cellType: DialogTableViewCell.self)) { _, dialog, cell in
                cell.configure(with: DialogTableViewCell.Model(recipientFullName: dialog.recipient?.fullName, recipientPhotoURL: dialog.recipient?.photoURL, lastMessageText: dialog.lastMessage?.text))
            }
            .disposed(by: disposeBag)
    }

}
