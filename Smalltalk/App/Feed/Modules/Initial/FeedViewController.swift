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

        setupUI()

        viewModel
            .setup(with: FeedViewModel.Input())
            .disposed(by: disposeBag)

        viewModel
            .posts
            .bind(to: tableView.rx.items(cellIdentifier: PostTableViewCell.reuseIdentifier,
                                         cellType: PostTableViewCell.self)) { _, post, cell in
                if cell.viewModel == nil {
                    cell.viewModel = AppDelegate.container.resolve(PostTableViewCellViewModel.self, argument: post)
                }
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Private
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let disposeBag = DisposeBag()

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        title = "Feed"

        view.addSubview(tableView)

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.reuseIdentifier)
    }

}
