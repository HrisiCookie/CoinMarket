//
//  CurrencyModel.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation

struct CurrencyModel: Codable {
    let id: String
    let name: String
    let symbol: String
    let rank: String
    let price_usd: String
    let price_btc: String
}
