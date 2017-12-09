//
//  FavouritesTableViewCell.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 9.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {

    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var currencyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(symbol: String, name: String) {
        symbolLabel.text = symbol
        currencyNameLabel.text = name
    }
}
