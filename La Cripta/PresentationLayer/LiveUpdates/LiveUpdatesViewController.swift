//
//  LiveUpdateViewController.swift
//  La Cripta
//
//  Created by Bagas Ilham on 27/07/22.
//

import UIKit

final class LiveUpdatesViewController: UITableViewController {
    
    private var socketConnection: URLSessionWebSocketTask?
    var coinName: String
    var fullName: String
    var openValue: Double?
    private var liveUpdateData: LCWSDataResponse?
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .label
        return indicator
    }()
    
    init(coinName: String, fullName: String, openValue: Double?) {
        self.coinName = coinName
        self.fullName = fullName
        self.openValue = openValue
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disconnectFromSocket()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingIndicator()
        connectToSocket()
        sendSubscription()
        receiveMessage()
        prepareTableView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if liveUpdateData != nil {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToplistsTableViewCell.self)", for: indexPath) as? ToplistsTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let data = liveUpdateData {
            print(data)
            cell.fill(with: data, fullName: self.fullName, openValue: self.openValue)
        }
        return cell
    }
    
    private func prepareTableView() {
        tableView.register(ToplistsTableViewCell.self, forCellReuseIdentifier: "\(ToplistsTableViewCell.self)")
        tableView.separatorStyle = .none
    }
    
    private func connectToSocket() {
        loadingIndicator.startAnimating()
      let url = URL(string: "wss://streamer.cryptocompare.com/v2?api_key=c659c5d742dd729eb6590ffd2369bc8bae00c99577485b09051165f4813b5e0b")!
      socketConnection = URLSession.shared.webSocketTask(with: url)
      socketConnection?.resume()
    }
    
    private func sendSubscription() {
      do {
          let encoder = JSONEncoder()
          let subscription = LCSubscriptionMessage(action: "SubAdd", subs: ["0~Coinbase~\(coinName)~USD"])
          let data = try encoder.encode(subscription)
          let message = URLSessionWebSocketTask.Message.data(data)
          socketConnection?.send(message) { [weak self] error in
              guard let _ = self else { return }
              if let error = error {
                  print(error)
              }
          }
      } catch {
          print(error)
      }
    }
    
    private func receiveMessage() {
        socketConnection?.receive { [weak self] result in
            guard let self = self else { return }
            defer {
                self.receiveMessage()
            }
            do {
                let message = try result.get()
                switch message {
                case let .string(string):
                    let jsonData = Data(string.utf8)
                    let decodedString = try JSONDecoder().decode(LCWSDataResponse.self, from: jsonData)
                    self.liveUpdateData = decodedString
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.loadingIndicator.stopAnimating()
                    }
                case let .data(data):
                    print(data)
                default:
                    print("unkown message received")
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func disconnectFromSocket() {
        socketConnection?.cancel(with: .normalClosure, reason: nil)
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 96)
        ])
    }
}
