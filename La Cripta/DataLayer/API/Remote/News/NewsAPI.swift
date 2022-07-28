//
//  NewsAPI.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import Foundation
import Alamofire

struct NewsAPI {
    var urlString: String
    
    init(query: String) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/everything"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        guard let urlString = urlComponents.url?.absoluteString else {
            self.urlString = "https://newsapi.org/v2/everything?q=\(query)"
            return
        }
        self.urlString = urlString
    }
    
    func getNews(
        _ completion: @escaping (LCNewsDataResponse?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [
            "X-Api-Key" : "e57cdec869d94425adb3725d2ea6df39",
            "Accept": "application/json"
        ]
        AF.request(
            urlString,
            method: .get,
            headers: headers
        )
            .validate()
            .responseDecodable(of: LCNewsDataResponse.self) { (response) in
                switch response.result {
                case let .success(result):
                    completion(result, nil)
                case let .failure(error):
                    completion(nil, error)
                    print(response.debugDescription)
                }
            }
    }
}
