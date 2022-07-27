//
//  LiveUpdateViewController.swift
//  La Cripta
//
//  Created by Bagas Ilham on 27/07/22.
//

import UIKit

final class LiveUpdatesViewController: UITableViewController {
    
    var subscriptions: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToplistsTableViewCell.self)") as? ToplistsTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
