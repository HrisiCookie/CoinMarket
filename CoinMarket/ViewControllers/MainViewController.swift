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
    
    @IBOutlet private weak var tableView: UITableView!
    
    var currencyService: CurrencyService = CurrencyService()
    var currenciesArray: [CurrencyModel] = []
    var coreDataService: CoreDataService = CoreDataService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        currencyService.currencyServiceDelegate = self
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
        currencyCell.delegate = self
        currencyCell.indexPath = indexPath.row
        
        currencyCell.populate(symbol: symbol, name: name)

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
    
extension MainViewController: CurrencyTableViewCellProtocol {
    func addToFavouritesBtnTapped(isAdded: Bool, atIndex: Int) {
        if isAdded {
            coreDataService.save(id: currenciesArray[atIndex].id, currency: currenciesArray[atIndex].name, symbol: currenciesArray[atIndex].symbol, priceUsd: currenciesArray[atIndex].price_usd, completion: { (completion) in
                if completion {
                    self.showAlert(title: addedToFavouritesTitle, message: addedToFavouritesMessage)
                    print("Added to favourites")
                }
            })
        } else {
            deleteDataWihtId(withId: currenciesArray[atIndex].id)
            self.showAlert(title: removedFromFavouritesTitle, message: removedFromFavouritesMessage)
        }
    }
    
    func deleteDataWihtId(withId id: String) {
        
        guard let managedObject = appDelegate?.persistentContainer.viewContext else {return}

        let fetchRequest = NSFetchRequest<FavouriteCurrency>(entityName: "FavouriteCurrency")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        
        guard let result = try? managedObject.fetch(fetchRequest) else {return}
        let resultData = result
        
        for object in resultData {
            managedObject.delete(object)
        }
        
        do {
            try managedObject.save()
            print("Removed from favourites!")
        } catch {
            print("Could not remove: \(error.localizedDescription)")
        }
    }
}
