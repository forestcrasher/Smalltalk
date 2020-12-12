//
//  ActivityViewController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import RxSwift
import RxCocoa

class ActivityViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: ActivityViewModel!

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
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: String(describing: NotificationTableViewCell.self))
        return tableView
    }()

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = "Activity"

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
            .setup(with: ActivityViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .notifications
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: NotificationTableViewCell.self), cellType: NotificationTableViewCell.self)) { _, notification, cell in
                cell.configure(with: NotificationTableViewCell.Model(
                                dispatcherFullName: notification.dispatcher?.fullName,
                                dispatcherPhotoURL: notification.dispatcher?.photoURL,
                                messageText: notification.message))
            }
            .disposed(by: disposeBag)
    }

}
