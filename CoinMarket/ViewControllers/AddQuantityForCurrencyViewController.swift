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
    @IBOutlet weak var cancelBtn: UIButton!
    
    var selectedCurrency: Currency?
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
        
        setupUI()
    }
    
    // private methods
    private func setupUI() {
        cancelBtn.layer.borderWidth = 2
        cancelBtn.layer.borderColor = #colorLiteral(red: 0.566865624, green: 0.7903254693, blue: 1, alpha: 1)
        navigationController?.navigationBar.tintColor = .white
        momentPriceForUSD.text = selectedCurrency?.priceUsd
        resultForUSD.text = "\(calculatedResult)"
    }
    
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
        coreDataService.saveResult(currency: currency, result: calculatedResult) { (completed) in
            if completed {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
