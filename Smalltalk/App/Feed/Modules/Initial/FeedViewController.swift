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
    var viewModel: FeedViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = "Feed"

        setupTableView()

        viewModel
            .setup(with: FeedViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .posts
            .bind(to: tableView.rx.items(cellIdentifier: PostTableViewCell.reuseIdentifier,
                                         cellType: PostTableViewCell.self)) { _, post, cell in
                cell.viewModel = AppDelegate.container.resolve(PostTableViewCellViewModel.self, argument: post)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)
    }

}
