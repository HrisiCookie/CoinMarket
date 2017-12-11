//
//  AddToFavouritesButton.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation
import UIKit

class AddToFavouritesButton: UIButton {
    // Images
    let checkedImage = UIImage(named: "addedToFavourites")
    let uncheckedImage = UIImage(named: "addToFavourites")
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setBackgroundImage(checkedImage, for: .normal)
            } else {
                self.setBackgroundImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}

