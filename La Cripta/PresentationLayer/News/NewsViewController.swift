//
//  NewsTableViewController.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import UIKit

final class NewsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(NewsTableViewCell.self)", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.fillWithDummyData()
        return cell
    }
    
    private func setupTableView() {
        navigationItem.title = "News"
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "\(NewsTableViewCell.self)")
        tableView.separatorStyle = .none
    }
}
