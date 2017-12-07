	//
//  MainViewController.swift
//  CoinMarket
//
//  Created by Hristina Bailova on 7.12.17.
//  Copyright © 2017 Hristina Bailova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var httpRequester: HttpRequester = HttpRequester()
    var currenciesArray: [CurrencyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        httpRequester.delegate = self
        httpRequester.get(from: APIUrl)
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
        
        currencyCell.populate(symbol: symbol, name: name)
        
        return currencyCell
    }
}

// MARK: - HttpRequesterDelegate
extension MainViewController: HttpRequesterDelegate {
    func didGetSuccess(with data: Data) {
        print("Success!!")
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode([CurrencyModel].self, from: data)
            if currenciesArray.count == 0 {
                currenciesArray = response
            } else {
                currenciesArray.append(contentsOf: response)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            print("Response!!!: \(response)")
        } catch {
            print("Can't convert data from JSON")
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func didGetFailed(with error: String) {
        print("Error: \(error)")
        self.showAlert(title: errorTitle, message: "\(error)")
    }
}
