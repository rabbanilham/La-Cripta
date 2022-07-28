//
//  LCToplistResponse.swift
//  La Cripta
//
//  Created by Bagas Ilham on 26/07/22.
//

import Foundation

struct LCToplistDataResponse: Codable {
    let message: String
    let type: Int
    let toplists: [LCToplistResponse]

    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case type = "Type"
        case toplists = "Data"
    }
}

struct LCToplistResponse: Codable {
    let coinInfo: LCCoinInfoResponse
    let raw: LCRawInfoResponse?

    enum CodingKeys: String, CodingKey {
        case coinInfo = "CoinInfo"
        case raw = "RAW"
    }
}

struct LCCoinInfoResponse: Codable {
    let id, name, fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case fullName = "FullName"
    }
}

struct LCRawInfoResponse: Codable {
    let usd: LCRawUsdResponse

    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

struct LCRawUsdResponse: Codable {
    let type: String
    let price: Double
    let openDay, highDay, lowDay: Double
    let open24Hour, high24Hour, low24Hour: Double
    let openHour, highHour, lowHour: Double
    let change24Hour, changeDay, changeHour: Double
    
    enum CodingKeys: String, CodingKey {
        case type = "TYPE"
        case price = "PRICE"
        case openDay = "OPENDAY"
        case highDay = "HIGHDAY"
        case lowDay = "LOWDAY"
        case open24Hour = "OPEN24HOUR"
        case high24Hour = "HIGH24HOUR"
        case low24Hour = "LOW24HOUR"
        case openHour = "OPENHOUR"
        case highHour = "HIGHHOUR"
        case lowHour = "LOWHOUR"
        case change24Hour = "CHANGE24HOUR"
        case changeDay = "CHANGEDAY"
        case changeHour = "CHANGEHOUR"
    }
}
