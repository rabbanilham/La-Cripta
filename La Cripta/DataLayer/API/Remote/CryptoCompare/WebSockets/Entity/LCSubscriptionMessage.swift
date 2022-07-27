//
//  LCSubscriptionMessage.swift
//  La Cripta
//
//  Created by Bagas Ilham on 27/07/22.
//

import Foundation

struct LCSubscriptionMessage: Encodable {
    let action : String
    let subs : [String]
}
