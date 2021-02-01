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
    private let viewModel: ActivityViewModel

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        return activityIndicatorView
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = R.color.labelColor()
        return refreshControl
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 48.0 + 32.0 + 16.0
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = R.color.backgroundColor()
        tableView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: String(describing: NotificationTableViewCell.self))
        return tableView
    }()

    private let editBarButtonItem: UIBarButtonItem = {
        let editButton = UIButton(type: .system)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSAttributedString(string: R.string.localizable.editButton(), attributes: [.font: UIFont.systemFont(ofSize: 17.0)])
        editButton.setAttributedTitle(attributedString, for: .normal)
        return UIBarButtonItem(customView: editButton)
    }()

    // MARK: - Init
    init(viewModel: ActivityViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupInternalBindings()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.loadAction.accept(())
    }

    // MARK: - Private
    private func setupUI() {
        title = R.string.localizable.activityTitle()
        view.backgroundColor = R.color.backgroundColor()
        navigationItem.leftBarButtonItems = [editBarButtonItem]

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        tableView.addSubview(refreshControl)

        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupInternalBindings() {
        viewModel.loading
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.refreshing
            .drive(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel
            .notifications
            .drive(tableView.rx.items(cellIdentifier: String(describing: NotificationTableViewCell.self), cellType: NotificationTableViewCell.self)) { _, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)

        refreshControl.rx
            .controlEvent(.valueChanged)
            .asSignal()
            .emit(to: viewModel.refreshAction)
            .disposed(by: disposeBag)
    }

}
