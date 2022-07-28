//
//  ViewController.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit

enum valueChangeDuration {
    case day
    case hour
    case last24Hour
}

final class ToplistsViewController: UITableViewController {
    
    private var api: CryptocompareAPI = CryptocompareAPI.shared
    private var toplists: Array<LCToplistResponse> = []
    private var changeDuration: valueChangeDuration = .day
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
        setupNavigationBar()
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
        cell.fill(with: data, changeDuration: self.changeDuration)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        presentNewsController(index: row)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row = indexPath.row
        return goToLiveUpdateController(index: row)
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
            self.toplists = result.toplists
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
            self.toplists = result.toplists
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func presentNewsController(index: IndexPath.Index) {
        let coinName = toplists[index].coinInfo.fullName
        let newsApi = NewsAPI(query: coinName.lowercased())
        let viewController = NewsViewController(api: newsApi)
        viewController.navigationItem.title = "\(coinName) News"
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    private func goToLiveUpdateController(index: Int) -> UISwipeActionsConfiguration {
        let coin = toplists[index]
        let action = UIContextualAction(
            style: .normal,
            title: "Live Update"
        ) { [weak self] action, view, completion in
            guard let self = self else { return }
            let viewController: LiveUpdatesViewController = {
                switch self.changeDuration {
                case .day:
                    return LiveUpdatesViewController(
                        coinName: coin.coinInfo.name,
                        fullName: coin.coinInfo.fullName,
                        openValue: coin.raw?.usd.openDay
                    )
                case .hour:
                    return LiveUpdatesViewController(
                        coinName: coin.coinInfo.name,
                        fullName: coin.coinInfo.fullName,
                        openValue: coin.raw?.usd.openHour
                    )
                case .last24Hour:
                    return LiveUpdatesViewController(
                        coinName: coin.coinInfo.name,
                        fullName: coin.coinInfo.fullName,
                        openValue: coin.raw?.usd.open24Hour
                    )
                }
            }()
            viewController.navigationItem.title = "\(coin.coinInfo.name) Live Update"
            completion(true)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [action])
        return swipeActions
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        let changeDurationButton = UIBarButtonItem(
            image: UIImage(systemName: "clock.arrow.2.circlepath"),
            style: .plain,
            target: self,
            action: nil
        )
        changeDurationButton.menu = UIMenu(
            title: "Show value change by:",
            image: UIImage(systemName: "clock.arrow.2.circlepath"),
            identifier: nil,
            options: .displayInline,
            children: durationMenuElements()
        )
        navigationItem.rightBarButtonItem = changeDurationButton
    }
    
    private func durationMenuElements() -> [UIMenuElement] {
        var menus: [UIMenuElement] = []
        
        let byDay = UIAction(
            title: "Day",
            image: nil,
            identifier: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            self.changeDuration = .day
            self.tableView.reloadData()
        }
        let byHour = UIAction(
            title: "Hour",
            image: nil,
            identifier: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            self.changeDuration = .hour
            self.tableView.reloadData()
        }
        let by24Hour = UIAction(
            title: "24 Hour",
            image: nil,
            identifier: nil
        ) { [weak self] _ in
            guard let self = self else { return }
            self.changeDuration = .last24Hour
            self.tableView.reloadData()
        }
        menus.append(byDay)
        menus.append(byHour)
        menus.append(by24Hour)
        
        return menus
    }

}

