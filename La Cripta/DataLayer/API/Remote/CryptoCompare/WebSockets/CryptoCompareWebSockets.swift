//
//  CryptoCompareWebSockets.swift
//  La Cripta
//
//  Created by Bagas Ilham on 27/07/22.
//

import Foundation

class CryptoCompareWebSockets {
    enum messageAction: String {
        case subscribe = "SubAdd"
        case unsubscribe = "SubRemove"
    }
    var socketConnection:  URLSessionWebSocketTask?
    var subscriptions: [String]
    
    init(subscriptions: [String]) {
        self.subscriptions = subscriptions
    }

    func connectToSocket() {
      let url = URL(string: "wss://streamer.cryptocompare.com/v2")!
      socketConnection = URLSession.shared.webSocketTask(with: url)
      socketConnection?.resume()
    }
    
    func sendDataMessage(action: messageAction) {
      do {
        let encoder = JSONEncoder()
          let rawMessage = LCSubscriptionMessage(action: action.rawValue, subs: <#T##[String]#>)
        let data = try encoder.encode(rawMessage)
        let message = URLSessionWebSocketTask.Message.data(data)

        socketConnection?.send(message) { error in
          if let error = error {
            // handle the error
            print(error)
          }
        }
      } catch {
        // handle the error
        print(error)
      }
    }
    
    func setReceiveHandler() {
      socketConnection?.receive { result in
        defer { self.setReceiveHandler() }

        do {
          let message = try result.get()
          switch message {
          case let .string(string):
            print(string)
          case let .data(data):
            print(data)
          @unknown default:
            print("unkown message received")
          }
        } catch {
          // handle the error
          print(error)
        }
      }
    }
}
