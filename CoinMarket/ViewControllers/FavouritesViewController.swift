//
//  FavouritesViewController.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 9.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit
import CoreData

class FavouritesViewController: UIViewController {

    // outlets
    @IBOutlet private weak var tableView: UITableView!
    
    var favourites: [FavouriteCurrency] = []
    var currentFav: FavouriteCurrency?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    // private methods
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName:"\(FavouritesTableViewCell.self)", bundle: nil), forCellReuseIdentifier: "\(FavouritesTableViewCell.self)")
    }
    
    private func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                tableView.isHidden = favourites.count < 1 ? true : false
            }
        }
    }

    func fetch(completion: (_ complete: Bool) -> ()) {
        // fetch request - grab data from persistant storage
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        // fetch items that are in this entity
        let fetchRequest = NSFetchRequest<FavouriteCurrency>(entityName: "FavouriteCurrency")
        do {
            favourites = try managedContext.fetch(fetchRequest)
            print("Fav: \(favourites)")
            print("Successfully fatched data!")
            completion(true)
        } catch {
            print("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let favouritesCell = tableView.dequeueReusableCell(withIdentifier: "\(FavouritesTableViewCell.self)", for: indexPath) as? FavouritesTableViewCell else {return UITableViewCell()}
        
        if let symbol = favourites[indexPath.row].symbol,
            let name = favourites[indexPath.row].currency {
            currentFav = favourites[indexPath.row]
            let result = favourites[indexPath.row].result
            favouritesCell.populate(symbol: symbol, name: name, result: result)
        }
        
        return favouritesCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "\(AddQuantityForCurrencyViewController.self)") as? AddQuantityForCurrencyViewController else {return}
        controller.selectedCurrency = favourites[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
