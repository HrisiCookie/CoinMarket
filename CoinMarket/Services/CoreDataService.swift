//
//  CoreDataService.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 8.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    
    // save to Core Data
    func save(id: String, currency: String, symbol: String, priceUsd: String, completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let favouriteCurrency = FavouriteCurrency(context: managedContext)
        
        favouriteCurrency.currency = currency
        favouriteCurrency.symbol = symbol
        favouriteCurrency.priceUsd = priceUsd
        
        do {
            try managedContext.save()
            print("Successfully saved data!")
            completion(true)
        } catch {
            print("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // delete from Core Data
    func delete(currency: FavouriteCurrency) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        managedContext.delete(currency)
        
        do {
            try managedContext.save()
            print("Successfully deleted data!")
        } catch {
            print("Could not remove: \(error.localizedDescription)")
        }
    }
}
