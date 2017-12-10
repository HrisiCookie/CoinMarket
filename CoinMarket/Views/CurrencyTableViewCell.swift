//
//  CurrencyTableViewCell.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

protocol CurrencyTableViewCellProtocol: class {
    func addToFavouritesBtnTapped(isAdded: Bool, atIndex: Int)
}

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var addToFavouritesBtn: AddToFavouritesButton!
    
    weak var delegate: CurrencyTableViewCellProtocol?
    var indexPath: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(symbol: String, name: String, isAdded: Bool) {
        symbolLabel.text = symbol
        nameLabel.text = name
        addToFavouritesBtn.isChecked = isAdded
    }
    
    @IBAction private func didPressAddToFavouritesBtn(_ sender: Any) {
        delegate?.addToFavouritesBtnTapped(isAdded: !addToFavouritesBtn.isChecked, atIndex: indexPath)
    }
}
