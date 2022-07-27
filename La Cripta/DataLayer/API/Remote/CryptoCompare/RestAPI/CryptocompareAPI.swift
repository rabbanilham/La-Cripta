//
//  CryptocompareAPI.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import Foundation
import Alamofire

struct CryptocompareAPI {
    
    static let shared = CryptocompareAPI()
    let baseUrl: String = "https://min-api.cryptocompare.com/data/top/totalvolfull"
    let authKey: String = "c659c5d742dd729eb6590ffd2369bc8bae00c99577485b09051165f4813b5e0b"
    
    func getToplists(
        _ completion: @escaping (LCToplistResponse?, AFError?) -> Void
    ) {
        let headers: HTTPHeaders = [ "authorization" : authKey ]
//        let queries: urlq
        AF.request(
            baseUrl + "?limit=50&tsym=USD",
            method: .get,
            headers: headers
        )
        .validate()
        .responseDecodable(of: LCToplistResponse.self) { response in
            switch response.result {
            case let .success(data):
                completion(data, nil)
            case let .failure(error):
                completion(nil, error)
                print(response.debugDescription)
            }
        }
    }
}
