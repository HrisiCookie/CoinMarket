	//
//  MainViewController.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit
import CoreData

var appDelegate = UIApplication.shared.delegate as? AppDelegate

class MainViewController: UIViewController {
    
    // outlets
    @IBOutlet private weak var tableView: UITableView!
    
    var currencyService: CurrencyService = CurrencyService()
    var currenciesArray: [CurrencyModel] = []
    var coreDataService: CoreDataService = CoreDataService()
    var isSelected: Bool = false
    var favIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        currencyService.currencyServiceDelegate = self
        requestCurrencies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favIds = UserDefaults.standard.array(forKey: "favIds") as? [String] ?? [String]()
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
        tableView.tableFooterView = UIView()
    
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
        currencyCell.delegate = self
        currencyCell.indexPath = indexPath.row
        
        isSelected = favIds.contains(currenciesArray[indexPath.row].id) ? true : false
        
        currencyCell.populate(symbol: symbol, name: name, isAdded: isSelected)

        return currencyCell
    }
}

// MARK: - CurrencyServiceDelegate
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

// MARK: - CurrencyTableViewCellProtocol
extension MainViewController: CurrencyTableViewCellProtocol {
    func addToFavouritesBtnTapped(isAdded: Bool, atIndex: Int) {
        if isAdded {
            coreDataService.save(id: currenciesArray[atIndex].id, currency: currenciesArray[atIndex].name, symbol: currenciesArray[atIndex].symbol, priceUsd: currenciesArray[atIndex].price_usd, priceBtc: currenciesArray[atIndex].price_btc, completion: { (completion) in
                if completion {
                    self.favIds.append(currenciesArray[atIndex].id)
                    self.showAlert(title: addedToFavouritesTitle, message: addedToFavouritesMessage)
                }
            })
        } else {
            coreDataService.deleteDataWihtId(withId: currenciesArray[atIndex].id)
            if let index = favIds.index(of: currenciesArray[atIndex].id) {
                favIds.remove(at: index)
            }
            self.showAlert(title: removedFromFavouritesTitle, message: removedFromFavouritesMessage)
        }
        
        UserDefaults.standard.set(favIds, forKey: "favIds")
    }
}
