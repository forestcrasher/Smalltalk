//
//  FeedViewController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 01.12.2020.
//

import UIKit
import RxSwift
import RxCocoa

class FeedViewController: UIViewController {

    // MARK: - ViewModel
    private var viewModel: FeedViewModel

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
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: String(describing: PostTableViewCell.self))
        return tableView
    }()

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = R.color.backgroundColor()
        tableView.backgroundColor = R.color.backgroundColor()
        title = R.string.localizable.feedTitle()

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
            .setup(with: FeedViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .posts
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: PostTableViewCell.self), cellType: PostTableViewCell.self)) { _, post, cell in
                cell.configure(with: PostTableViewCell.Model(text: post.text, authorFullName: post.author?.fullName, authorPhotoURL: post.author?.photoURL, date: post.date))
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Init
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
