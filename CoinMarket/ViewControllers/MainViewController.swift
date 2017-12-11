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
    var savedResponse: [FavouriteCurrency] = []
    var isDataLoaded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        currencyService.currencyServiceDelegate = self
        
        isDataLoaded = UserDefaults.standard.bool(forKey: "isDataLoaded")
        
        if !isDataLoaded {
            requestCurrencies()
            isDataLoaded = true
            UserDefaults.standard.set(isDataLoaded, forKey: "isDataLoaded")
        }
        
        fetchCoreDataObjects()
    }
    
    private func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                tableView.isHidden = savedResponse.count < 1 ? true : false
            }
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        // fetch request - grab data from persistant storage
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        // fetch items that are in this entity
        let fetchRequest = NSFetchRequest<FavouriteCurrency>(entityName: "FavouriteCurrency")
        do {
            savedResponse = try managedContext.fetch(fetchRequest)
            print("Successfully fatched data!")
            completion(true)
        } catch {
            print("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
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
        return savedResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currencyCell = tableView.dequeueReusableCell(withIdentifier: "\(CurrencyTableViewCell.self)", for: indexPath) as? CurrencyTableViewCell else {return UITableViewCell()}
        
        let symbol = savedResponse[indexPath.row].symbol?.uppercased()
        let name = savedResponse[indexPath.row].currency
        let isAdded = savedResponse[indexPath.row].isAddedToFavourites
        currencyCell.delegate = self
        currencyCell.indexPath = indexPath.row
        
        currencyCell.populate(symbol: symbol!, name: name!, isAdded: isAdded)

        return currencyCell
    }
}

// MARK: - CurrencyServiceDelegate
extension MainViewController: CurrencyServiceDelegate {
    func didRegisterSuccess() {
        self.currenciesArray = currencyService.resultsArray
        
        DispatchQueue.main.async {
            for currency in self.currenciesArray {
                self.coreDataService.save(id: currency.id, currency: currency.name, symbol: currency.symbol, priceUsd: currency.price_usd, priceBtc: currency.price_btc, isAdded: false, completion: { (_) in
                    
                })
            }
            
            self.fetchCoreDataObjects()
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
            coreDataService.saveAsFav(currency: savedResponse[atIndex], isFav: true, completion: { (completion) in
                self.showAlert(title: addedToFavouritesTitle, message: addedToFavouritesMessage)
            })
        } else {
            coreDataService.saveAsFav(currency: savedResponse[atIndex], isFav: false, completion: { (completion) in
                self.showAlert(title: removedFromFavouritesTitle, message: removedFromFavouritesMessage)
            })
        }
    }
}
