//
//  AddQuantityForCurrencyViewController.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 10.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class AddQuantityForCurrencyViewController: UIViewController, UITextFieldDelegate {
    
    // outlets
    @IBOutlet private weak var quantityForUSD: UITextField!
    @IBOutlet private weak var momentPriceForUSD: UILabel!
    @IBOutlet private weak var resultForUSD: UILabel!
    
    var selectedCurrency: FavouriteCurrency?
    var result: Double = 0
    private let coreDataService: CoreDataService = CoreDataService()
    
    private var calculatedResult: Double {
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
    
    // private methods
    private func calculateResult() {
        if let quantity = quantityForUSD.text,
            let price = momentPriceForUSD.text,
            let doubleQuantity = Double(quantity),
            let doublePrice = Double(price) {
            calculatedResult = doubleQuantity * doublePrice
            resultForUSD.text = String(calculatedResult)
        }
    }
    
    // actions
    @IBAction func textFieldDidChange(_ sender: Any) {
        calculateResult()
    }
    
    @IBAction func didPressSubmitBtn(_ sender: Any) {
        guard let currency = selectedCurrency else {return}
        coreDataService.saveChanges(currency: currency, result: calculatedResult) { (completed) in
            if completed {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
