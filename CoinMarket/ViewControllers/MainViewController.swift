	//
//  MainViewController.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var currencyService: CurrencyService = CurrencyService()
//    var httpRequester: HttpRequester = HttpRequester()
    var currenciesArray: [CurrencyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        currencyService.currencyServiceDelegate = self
//        httpRequester.delegate = self
//        httpRequester.get(from: APIUrl)
        requestCurrencies()
    }
    
    func requestCurrencies() {
        currencyService.requestCurrencies()
    }
    
    // private methods
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
    
        self.tableView.register(UINib(nibName:"\(CurrencyTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(CurrencyTableViewCell.self)")
    }
}

    // MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currencyCell = tableView.dequeueReusableCell(withIdentifier: "\(CurrencyTableViewCell.self)", for: indexPath) as? CurrencyTableViewCell else {return UITableViewCell()}
        
        let symbol = currenciesArray[indexPath.row].symbol.uppercased()
        let name = currenciesArray[indexPath.row].name
        
        currencyCell.populate(symbol: symbol, name: name)
        
        return currencyCell
    }
}

extension MainViewController: CurrencyServiceDelegate {
    func didRegisterSuccess() {
        self.currenciesArray = currencyService.resultsArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
        
    func didRegisterFailure(withError: String) {
        DispatchQueue.main.async {
            self.showAlert(title: errorTitle, message: withError)
        }
    }
}
