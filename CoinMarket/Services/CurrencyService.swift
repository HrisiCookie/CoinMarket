//
//  CurrencyService.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation

protocol CurrencyServiceDelegate: class {
    func didRegisterSuccess()
    func didRegisterFailure(withError: String)
}

class CurrencyService {
    var httpRequester: HttpRequester = HttpRequester()
    var resultsArray: [CurrencyModel] = []
    
    weak var currencyServiceDelegate: CurrencyServiceDelegate?
    
    init() {
        httpRequester.delegate = self
    }
    
    func requestCurrencies() {
        httpRequester.get(from: APIUrl)
    }
}

extension CurrencyService: HttpRequesterDelegate {
    func didGetSuccess(with data: Data) {
        print("Success!!")
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode([CurrencyModel].self, from: data)
            if resultsArray.count == 0 {
                resultsArray = response
            } else {
                resultsArray.append(contentsOf: response)
            }
            
            currencyServiceDelegate?.didRegisterSuccess()
            print("Response!!!: \(response)")
        } catch {
            print("Can't convert data from JSON")
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func didGetFailed(with error: String) {
        currencyServiceDelegate?.didRegisterFailure(withError: error)
    }
}
