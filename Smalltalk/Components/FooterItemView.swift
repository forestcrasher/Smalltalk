//
//  FooterItemView.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 15.12.2020.
//

import UIKit

class FooterItemView: UIView {

    // MARK: - Public
    var countLikes: Int {
        get { Int(likeButton.title(for: .normal) ?? "0") ?? 0 }
        set { likeButton.setTitle(String(describing: newValue), for: .normal) }
    }

    var countReposts: Int {
        get { Int(repostButton.title(for: .normal) ?? "0") ?? 0 }
        set { repostButton.setTitle(String(describing: newValue), for: .normal) }
    }

    var countComments: Int {
        get { Int(commentButton.title(for: .normal) ?? "0") ?? 0 }
        set { commentButton.setTitle(String(describing: newValue), for: .normal) }
    }

    var likeEnabled = false {
        didSet {
            if likeEnabled {
                likeButton.setTitleColor(R.color.secondaryTintColor()!, for: .normal)
                likeButton.setTitleColor(R.color.secondaryTintColor()!.withAlphaComponent(0.3), for: .highlighted)
                likeButton.setImage(UIImage.heartFill?.withTintColor(R.color.secondaryTintColor()!), for: .normal)
                likeButton.setImage(UIImage.heartFill?.withTintColor(R.color.secondaryTintColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
                likeButton.tintColor = R.color.secondaryTintColor()
            } else {
                likeButton.setTitleColor(R.color.fillColor()!, for: .normal)
                likeButton.setTitleColor(R.color.fillColor()!.withAlphaComponent(0.3), for: .highlighted)
                likeButton.setImage(UIImage.heartFill?.withTintColor(R.color.fillColor()!), for: .normal)
                likeButton.setImage(UIImage.heartFill?.withTintColor(R.color.fillColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
                likeButton.tintColor = R.color.fillColor()
            }
        }
    }

    // MARK: - Private
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        return stackView
    }()

    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setTitleColor(R.color.fillColor()!, for: .normal)
        likeButton.setTitleColor(R.color.fillColor()!.withAlphaComponent(0.3), for: .highlighted)
        likeButton.setImage(UIImage.heartFill?.withTintColor(R.color.fillColor()!), for: .normal)
        likeButton.setImage(UIImage.heartFill?.withTintColor(R.color.fillColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
        likeButton.tintColor = R.color.fillColor()
        likeButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        stackView.addArrangedSubview(likeButton)
        return likeButton
    }()

    private lazy var repostButton: UIButton = {
        let repostButton = UIButton()
        repostButton.translatesAutoresizingMaskIntoConstraints = false
        repostButton.setImage(UIImage.arrowshapeTurnUpRightFill, for: .normal)
        repostButton.setTitleColor(R.color.fillColor()!, for: .normal)
        repostButton.setTitleColor(R.color.fillColor()!.withAlphaComponent(0.3), for: .highlighted)
        repostButton.setImage(UIImage.arrowshapeTurnUpRightFill?.withTintColor(R.color.fillColor()!), for: .normal)
        repostButton.setImage(UIImage.arrowshapeTurnUpRightFill?.withTintColor(R.color.fillColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
        repostButton.tintColor = R.color.fillColor()
        repostButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        stackView.addArrangedSubview(repostButton)
        return repostButton
    }()

    private lazy var commentButton: UIButton = {
        let commentButton = UIButton()
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.setImage(UIImage.bubbleRightFill, for: .normal)
        commentButton.setTitleColor(R.color.fillColor()!, for: .normal)
        commentButton.setTitleColor(R.color.fillColor()!.withAlphaComponent(0.3), for: .highlighted)
        commentButton.setImage(UIImage.bubbleRightFill?.withTintColor(R.color.fillColor()!), for: .normal)
        commentButton.setImage(UIImage.bubbleRightFill?.withTintColor(R.color.fillColor()!.withAlphaComponent(0.3), renderingMode: .alwaysOriginal), for: .highlighted)
        commentButton.tintColor = R.color.fillColor()
        commentButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 0.0)
        stackView.addArrangedSubview(commentButton)
        return commentButton
    }()

    private func setupUI() {
        heightAnchor.constraint(equalToConstant: 48.0).isActive = true

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
