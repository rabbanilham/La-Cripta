//
//  NewsTableViewCell.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit
import Kingfisher

final class NewsTableViewCell: UITableViewCell {
    
    private var borderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor.label.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()
    var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private var articleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private var bottomSquareView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .label
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        return view
    }()
    private var articleAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBackground
        return label
    }()
    private var articlePublishTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 10)
        label.textColor = .systemBackground
        return label
    }()
    private var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBackground
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(Any.self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onShareButtonTap: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        defineLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func defineLayout() {
        contentView.clipsToBounds = true
        contentView.addSubview(borderView)
        borderView.addSubviews(
            articleImageView,
            articleTitleLabel,
            articleDescriptionLabel,
            bottomSquareView
        )
        bottomSquareView.addSubviews(
            articleAuthorLabel,
            articlePublishTimeLabel,
            shareButton
        )
        
        let margin = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: margin.topAnchor),
            borderView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            borderView.widthAnchor.constraint(equalTo: margin.widthAnchor),
            borderView.centerXAnchor.constraint(equalTo: margin.centerXAnchor),
            
            articleImageView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 8),
            articleImageView.widthAnchor.constraint(equalTo: borderView.widthAnchor, constant: -16),
            articleImageView.heightAnchor.constraint(equalToConstant: 180),
            articleImageView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            
            articleTitleLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8),
            articleTitleLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 16),
            articleTitleLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -16),
            articleTitleLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            
            articleDescriptionLabel.topAnchor.constraint(equalTo: articleTitleLabel.bottomAnchor, constant: 8),
            articleDescriptionLabel.leadingAnchor.constraint(equalTo: articleTitleLabel.leadingAnchor),
            articleDescriptionLabel.trailingAnchor.constraint(equalTo: articleTitleLabel.trailingAnchor),
            articleDescriptionLabel.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            
            bottomSquareView.topAnchor.constraint(equalTo: articleDescriptionLabel.bottomAnchor, constant: 16),
            bottomSquareView.widthAnchor.constraint(equalTo: borderView.widthAnchor, constant: -16),
            bottomSquareView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -8),
            bottomSquareView.centerXAnchor.constraint(equalTo: borderView.centerXAnchor),
            
            articleAuthorLabel.topAnchor.constraint(equalTo: bottomSquareView.topAnchor, constant: 8),
            articleAuthorLabel.leadingAnchor.constraint(equalTo: bottomSquareView.leadingAnchor, constant: 8),
            articleAuthorLabel.trailingAnchor.constraint(equalTo: margin.centerXAnchor, constant: UIScreen.main.bounds.width / 5),
            
            articlePublishTimeLabel.topAnchor.constraint(equalTo: articleAuthorLabel.bottomAnchor, constant: 4),
            articlePublishTimeLabel.bottomAnchor.constraint(equalTo: bottomSquareView.bottomAnchor, constant: -8),
            articlePublishTimeLabel.leadingAnchor.constraint(equalTo: articleAuthorLabel.leadingAnchor),
            
            shareButton.trailingAnchor.constraint(equalTo: bottomSquareView.trailingAnchor, constant: -16),
            shareButton.centerYAnchor.constraint(equalTo: bottomSquareView.centerYAnchor)
        ])
    }
    
    func fill(with data: LCArticleResponse) {
        if let url = URL(string: data.urlToImage ?? "") {
            articleImageView.kf.indicatorType = .activity
            articleImageView.kf.setImage(with: url, options: [.transition(.fade(0.25))])
        }
        articleTitleLabel.text = data.title
        articleDescriptionLabel.attributedText = NSMutableAttributedString(
            string: data.articleDescription
        )
        .addLineSpacing(4)
        if let author = data.author, author.isEmpty == false {
            articleAuthorLabel.text = "\(data.author ?? "") - \(data.source.name)"
        } else {
            articleAuthorLabel.text = data.source.name
        }
        articlePublishTimeLabel.text = data.publishedAt.convertToDateInterval() + " ago"
    }
    
    @objc private func shareButtonTapped() {
        onShareButtonTap?()
    }
    
}
