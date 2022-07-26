//
//  ViewController.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit

final class ToplistsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToplistsTableViewCell.self)", for: indexPath) as? ToplistsTableViewCell else { return UITableViewCell() }
        cell.nameLabel.text = "BTC"
        cell.fullNameLabel.text = "Bitcoin"
        cell.priceLabel.text = "$ 42,303.9"
        cell.tickerLabel.text = "-94.63(0.22%)"
        cell.handleTickerValue()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = NewsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    private func setupTableView() {
        navigationItem.title = "Toplists"
        tableView.register(ToplistsTableViewCell.self, forCellReuseIdentifier: "\(ToplistsTableViewCell.self)")
    }

}
