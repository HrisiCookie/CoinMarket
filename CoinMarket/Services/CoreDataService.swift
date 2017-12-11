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
    func save(id: String, currency: String, symbol: String, priceUsd: String, priceBtc: String, isAdded: Bool, completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let favouriteCurrency = Currency(context: managedContext)
        
        favouriteCurrency.id = id
        favouriteCurrency.currency = currency
        favouriteCurrency.symbol = symbol
        favouriteCurrency.priceUsd = priceUsd
        favouriteCurrency.priceBtc = priceBtc
        favouriteCurrency.result = 0.0
        favouriteCurrency.isAddedToFavourites = isAdded
        
        do {
            try managedContext.save()
            print("Successfully saved data!")
            completion(true)
        } catch {
            print("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func saveResult(currency: Currency, result: Double, completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        currency.result = result
        
        do {
            try managedContext.save()
            print("Successfully updated data!")
            completion(true)
        } catch {
            print("Could not update: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func saveAsFav(currency: Currency, isFav: Bool, completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        currency.isAddedToFavourites = isFav
        
        do {
            try managedContext.save()
            print("Added to favourites")
            completion(true)
        } catch {
            print("Could not add to favourites: \(error.localizedDescription)")
            completion(false)
        }
    }
}
