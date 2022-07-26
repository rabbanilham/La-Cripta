//
//  NewsTableViewController.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit
import SafariServices
import Kingfisher

final class NewsViewController: UITableViewController, SFSafariViewControllerDelegate {
    
    private var articles: Array<LCArticleResponse> = []
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .label
        return indicator
    }()
    var api: NewsAPI
    
    init(api: NewsAPI) {
        self.api = api
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clearKingfisherCache()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        setupLoadingIndicator()
        loadNews()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(NewsTableViewCell.self)",
            for: indexPath
        ) as? NewsTableViewCell
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        let article = articles[row]
        cell.fill(with: article)
        cell.onShareButtonTap = { [weak self] in
            guard let self = self else { return }
            self.showShareActivityController(article: article, row: row)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let article = articles[row]
        presentSafariViewController(article: article)
    }
    
    private func setupTableView() {
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "\(NewsTableViewCell.self)")
        tableView.separatorStyle = .none
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
        let sorterButton = UIBarButtonItem(
            title: "Sort",
            style: .plain,
            target: self,
            action: nil
        )
        sorterButton.menu = UIMenu(
            title: "Sort news by:",
            image: nil,
            identifier: nil,
            options: .displayInline,
            children: sortMenuElements()
        )
        navigationItem.leftBarButtonItem = sorterButton
        let dismissButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
        navigationItem.rightBarButtonItem = dismissButton
    }
    
    private func loadNews() {
        loadingIndicator.startAnimating()
        api.getNews { [weak self] result, error in
            guard let self = self, let result = result else {
                let alert = UIAlertController(
                    title: "Error",
                    message: "An error occured while fetching news.",
                    preferredStyle: .alert
                )
                let dismiss = UIAlertAction(title: "Dismiss News", style: .destructive) { [weak self] _ in
                    guard let self = self else { return }
                    self.performDismissView()
                }
                let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    self.loadNews()
                }
                alert.addAction(dismiss)
                alert.addAction(retry)
                self?.present(alert, animated: true)
                return
            }
            self.articles = result.articles.sorted(by: {$0.publishedAt > $1.publishedAt})
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func sortMenuElements() -> [UIMenuElement] {
        var menus: [UIMenuElement] = []
        let sortByLatest = UIAction(
            title: "Latest",
            image: UIImage(systemName: "arrow.uturn.down"),
            identifier: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            self.articles.sort(by: {$0.publishedAt > $1.publishedAt})
            self.tableView.reloadData()
        }
        let sortByOldest = UIAction(
            title: "Oldest",
            image: UIImage(systemName: "arrow.uturn.up"),
            identifier: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            self.articles.sort(by: {$0.publishedAt < $1.publishedAt})
            self.tableView.reloadData()
        }
        let random = UIAction(
            title: "Random",
            image: UIImage(systemName: "arrow.triangle.swap"),
            identifier: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            self.articles.shuffle()
            self.tableView.reloadData()
        }
        menus.append(sortByLatest)
        menus.append(sortByOldest)
        menus.append(random)
        
        return menus
    }
    
    private func presentSafariViewController(article: LCArticleResponse) {
        if let url = URL(string: article.url) {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            present(safariViewController, animated: true)
        }
    }
    
    private func showShareActivityController(article: LCArticleResponse, row: Int) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? NewsTableViewCell else { return }
        if let image = cell.articleImageView.image {
            LCNewsSharer.shared.share(in: self, article: article, image: image)
        } else {
            LCNewsSharer.shared.share(in: self, article: article, image: UIImage(systemName: "photo.fill")!)
        }
        
    }
    
    private func performDismissView() {
        self.dismiss(animated: true)
    }
    
    private func clearKingfisherCache() {
        Kingfisher.KingfisherManager.shared.cache.clearCache()
    }
    
    @objc private func dismissView() {
        self.performDismissView()
    }
}
