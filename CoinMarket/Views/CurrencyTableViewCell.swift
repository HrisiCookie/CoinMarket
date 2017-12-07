//
//  CurrencyTableViewCell.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(symbol: String, name: String) {
        symbolLabel.text = symbol
        nameLabel.text = name
    }
}
