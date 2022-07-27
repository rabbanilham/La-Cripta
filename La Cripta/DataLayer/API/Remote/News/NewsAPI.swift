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
    var newsType: String
    
    enum newsEndpoint: String {
        case everything = "everything"
        case topHeadlines = "top-headlines"
    }
    
    init(newsType: newsEndpoint, coinName: String) {
        self.newsType = newsType.rawValue
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/\(newsType.rawValue)"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: coinName)
        ]
        guard let urlString = urlComponents.url?.absoluteString else {
            self.urlString = "https://newsapi.org/v2/everything?q=\(coinName)"
            return
        }
        self.urlString = urlString
    }
    
    func getNews(
        _ completion: @escaping (LCNewsDataResponse?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [
            "X-Api-Key" : "aae0541e580544f8a6370ccb489a2b00",
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
