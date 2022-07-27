//
//  ViewController.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit

final class ToplistsViewController: UITableViewController {
    
    private var api: CryptocompareAPI = CryptocompareAPI.shared
    private var toplists: Array<LCToplistsDataResponse> = []
    private var newsApiEndpoint: NewsAPI.newsEndpoint = .everything
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .label
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoadingIndicator()
        setupRefreshControl()
        loadToplists()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toplists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(ToplistsTableViewCell.self)",
            for: indexPath
        ) as? ToplistsTableViewCell
        else { return UITableViewCell() }
        let data = toplists[row]
        cell.fill(with: data)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        presentNewsController(index: row)
    }
    
    private func setupTableView() {
        navigationItem.title = "Toplists"
        tableView.register(ToplistsTableViewCell.self, forCellReuseIdentifier: "\(ToplistsTableViewCell.self)")
    }
    
    private func loadToplists() {
        loadingIndicator.startAnimating()
        api.getToplists { [weak self] result, error in
            guard let self = self, let result = result else {
                let alert = UIAlertController(
                    title: "Error",
                    message: "An error occured while fetching data.",
                    preferredStyle: .alert
                )
                let refresh = UIAlertAction(title: "Try Again", style: .default) { _ in
                    self?.loadToplists()
                }
                alert.addAction(refresh)
                self?.present(alert, animated: true)
                return
            }
            self.toplists = result.data
            self.tableView.reloadData()
            self.loadingIndicator.stopAnimating()
        }
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshPage), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc private func refreshPage() {
        api.getToplists { [weak self] result, error in
            guard let self = self, let result = result else {
                let alert = UIAlertController(
                    title: "Error",
                    message: "An error occured while fetching data.",
                    preferredStyle: .alert
                )
                let refresh = UIAlertAction(title: "Try Again", style: .default) { _ in
                    self?.loadToplists()
                }
                alert.addAction(refresh)
                self?.present(alert, animated: true)
                return
            }
            self.toplists = result.data
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func presentNewsController(index: IndexPath.Index) {
        let coinName = toplists[index].coinInfo.fullName
        let newsApi = NewsAPI(newsType: newsApiEndpoint, coinName: coinName.lowercased())
        let viewController = NewsViewController(api: newsApi)
        viewController.navigationItem.title = "\(coinName) News"
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }

}

