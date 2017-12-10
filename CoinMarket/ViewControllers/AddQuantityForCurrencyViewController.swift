//
//  AddQuantityForCurrencyViewController.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 10.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class AddQuantityForCurrencyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var quantityForUSD: UITextField!
    @IBOutlet weak var momentPriceForUSD: UILabel!
    @IBOutlet weak var resultForUSD: UILabel!
    
    var selectedCurrency: FavouriteCurrency?
    var result: Double = 0
    
    var calculatedResult: Double {
        get {
            return result
        } set(value) {
            print(value)
            result = value
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantityForUSD.delegate = self
        self.hideKeyboardWhenTapped()
        
        momentPriceForUSD.text = selectedCurrency?.priceUsd
        resultForUSD.text = "\(calculatedResult)"
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        calculateResult()
    }
    
    func calculateResult() {
        if let quantity = quantityForUSD.text,
            let price = momentPriceForUSD.text,
            let doubleQuantity = Double(quantity),
            let doublePrice = Double(price) {
            calculatedResult = doubleQuantity * doublePrice
            resultForUSD.text = String(calculatedResult)
        }
    }
    
    @IBAction func didPressSubmitBtn(_ sender: Any) {
    }
    
}
