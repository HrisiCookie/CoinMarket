//
//  File.swift
//  RandomUsers
//
//  Created by Cookie on 24.11.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
    }
}
