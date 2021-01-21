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
    private var viewModel: MessagesViewModel

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if viewModel.loading.value {
            setupInternalBindings()
        }
    }

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
        let rowHeight: CGFloat = 60.0
        let rowPadding: CGFloat = 32.0
        let rowMargin: CGFloat = 16.0
        let verticalPadding: CGFloat = 8.0
        tableView.rowHeight = rowHeight + rowPadding + rowMargin
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = R.color.backgroundColor()
        tableView.contentInset = UIEdgeInsets(top: verticalPadding, left: 0.0, bottom: verticalPadding, right: 0.0)
        tableView.register(DialogTableViewCell.self, forCellReuseIdentifier: String(describing: DialogTableViewCell.self))
        return tableView
    }()

    private let editBarButtonItem: UIBarButtonItem = {
        let editButton = UIButton(type: .system)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSAttributedString(string: R.string.localizable.editButton(), attributes: [.font: UIFont.systemFont(ofSize: 17.0)])
        editButton.setAttributedTitle(attributedString, for: .normal)
        return UIBarButtonItem(customView: editButton)
    }()

    private let writeBarButtonItem: UIBarButtonItem = {
        let writeButton = UIButton(type: .system)
        writeButton.translatesAutoresizingMaskIntoConstraints = false
        writeButton.setImage(UIImage.squareAndPencil?.withTintColor(R.color.fillColor()!), for: .normal)
        writeButton.setImage(UIImage.squareAndPencil?.withTintColor(R.color.fillColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
        return UIBarButtonItem(customView: writeButton)
    }()

    // MARK: - Init
    init(viewModel: MessagesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    private func setupUI() {
        title = R.string.localizable.messagesTitle()
        view.backgroundColor = R.color.backgroundColor()
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.leftBarButtonItems = [editBarButtonItem]
        navigationItem.rightBarButtonItems = [writeBarButtonItem]

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
        viewModel
            .setup(with: MessagesViewModel.Input(refreshDialogs: refreshControl.rx.controlEvent(.valueChanged).asSignal()))
            .disposed(by: disposeBag)

        viewModel.loading
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.refreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel
            .dialogs
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: DialogTableViewCell.self), cellType: DialogTableViewCell.self)) { _, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
    }

}
