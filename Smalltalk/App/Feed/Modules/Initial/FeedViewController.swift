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
        tableView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
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

        Observable.combineLatest(viewModel.posts, viewModel.currentUser)
            .map { (posts, currentUser) in posts.map { ($0, currentUser) } }
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: PostTableViewCell.self), cellType: PostTableViewCell.self)) { _, data, cell in
                let (post, currentUser) = data
                let model = PostTableViewCell.Model(
                    text: post.text,
                    userFullName: post.author?.fullName,
                    userPhotoURL: post.author?.photoURL,
                    date: post.date,
                    countLikes: post.countLikes,
                    countReposts: post.countReposts,
                    countComments: post.countComments,
                    likeEnabled: post.likes.contains(currentUser?.id ?? ""))
                cell.configure(with: model)
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
