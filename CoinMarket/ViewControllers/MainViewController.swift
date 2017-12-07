	//
//  MainViewController.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var httpRequester: HttpRequester = HttpRequester()

    override func viewDidLoad() {
        super.viewDidLoad()

        httpRequester.delegate = self
        httpRequester.get(from: APIUrl)
        // Do any additional setup after loading the view.
    }
}

extension MainViewController: HttpRequesterDelegate {
    func didGetSuccess(with data: Data) {
        print("Success!!")
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode([CurrencyModel].self, from: data)
            print("Response!!!: \(response)")
        } catch {
            print("Can't convert data from JSON")
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func didGetFailed(with error: String) {
        print("Error: \(error)")
    }
}
