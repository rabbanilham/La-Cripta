//
//  NewsTableViewCell.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit
import Kingfisher

final class NewsTableViewCell: UITableViewCell {
    
    var borderView: UIView = {
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
    
    var articleTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    var articleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    var bottomSquareView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .label
        view.heightAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        return view
    }()
    
    var articleAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBackground
        return label
    }()
    
    var articlePublishTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 10)
        label.textColor = .systemBackground
        return label
    }()
    
    var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBackground
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.addTarget(Any.self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemBackground
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.addTarget(Any.self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    typealias OnShareButtonTap = () -> Void
    var onShareButtonTap: OnShareButtonTap?
    typealias OnSaveButtonTap = () -> Void
    var onSaveButtonTap: OnShareButtonTap?
    
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
            shareButton,
            saveButton
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
            
            articlePublishTimeLabel.topAnchor.constraint(equalTo: articleAuthorLabel.bottomAnchor, constant: 4),
            articlePublishTimeLabel.bottomAnchor.constraint(equalTo: bottomSquareView.bottomAnchor, constant: -8),
            articlePublishTimeLabel.leadingAnchor.constraint(equalTo: articleAuthorLabel.leadingAnchor),
            
            shareButton.trailingAnchor.constraint(equalTo: bottomSquareView.trailingAnchor, constant: -16),
            shareButton.centerYAnchor.constraint(equalTo: bottomSquareView.centerYAnchor),
            
            saveButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor)
        ])
    }
    
    func fillWithDummyData() {
        let json =
    """
        {
            "status": "ok",
            "totalResults": 13321,
            "articles": [
                {
                    "source": {
                        "id": "engadget",
                        "name": "Engadget"
                    },
                    "author": "Jon Fingas",
                    "title": "Google Maps now shows toll prices on Android and iOS",
                    "description": "Google Maps can already help you avoid toll roads, but now it will let you know just how much you'll pay if you take those (supposedly) quicker routes. Android Policenotes that Google has enabled its previously promised toll pricing in Maps for Android and iO…",
                    "url": "https://www.engadget.com/google-maps-toll-road-prices-134349642.html",
                    "urlToImage": "https://s.yimg.com/os/creatr-uploaded-images/2022-06/804a8140-ebe4-11ec-bbee-cd90acb31749",
                    "publishedAt": "2022-06-14T13:43:49Z",
                    "content": "Google Maps can already help you avoid toll roads, but now it will let you know just how much you'll pay if you take those (supposedly) quicker routes. Android Policenotes that Google has enabled its… [+585 chars]"
                }
            ]
        }
    """
        
        do {
            let jsonData = Data(json.utf8)
            let news: LCNewsDataResponse = try JSONDecoder().decode(LCNewsDataResponse.self, from: jsonData)
            guard news.articles.isEmpty == false else { return }
            let article = news.articles[0]
            self.fill(with: article)
        } catch {
            print(String(describing: error))
        }
    }
    
    func fill(with data: LCArticleResponse) {
        if let url = URL(string: data.urlToImage) {
            articleImageView.kf.indicatorType = .activity
            articleImageView.kf.setImage(with: url, options: [.transition(.fade(0.25))])
        }
        articleTitleLabel.text = data.title
        articleDescriptionLabel.attributedText = NSMutableAttributedString(
            string: data.articleDescription
        )
        .formatForNewsDescription()
        articleAuthorLabel.text = data.author
        articlePublishTimeLabel.text = data.publishedAt.convertToDateInterval() + " ago"
    }
    
    @objc private func shareButtonTapped() {
        onShareButtonTap?()
    }
    
    @objc private func saveButtonTapped() {
        onSaveButtonTap?()
        saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
    }
    
}
