//
//  LCWSDataResponse.swift
//  La Cripta
//
//  Created by Bagas Ilham on 27/07/22.
//

import Foundation

struct LCWSDataResponse: Codable {
    let type, fromSymbol, toSymbol: String
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case type = "TYPE"
        case fromSymbol = "FSYM"
        case toSymbol = "TSYM"
        case price = "P"
    }
}
