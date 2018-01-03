//
//  ViewController.swift
//  BitcoinCalculator
//
//  Created by Lillie Zhou on 1/2/18.
//  Copyright © 2018 Lillie Zhou. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {
    
    let url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var selectedCurrencyIndex = 0

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    // Send an HTTP request to BitcoinAverage API
    func getCurrency(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let currencyJSON: JSON = JSON(response.result.value!)
                self.parse(json: currencyJSON)
            } else {
                self.priceLabel.text = "Conversion Unsuccessful"
            }
        }
    }
    
    // Parse the JSON response
    func parse(json: JSON) {
        if let convertedPrice = json["ask"].double {
            let selectedCurrencySymbol = currencySymbolArray[selectedCurrencyIndex]
            priceLabel.text = "\(selectedCurrencySymbol)\(convertedPrice)"
        }
    }
    
    // Define # of columns in PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Define # of rows in PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // Each row in the PickerView is set to a unique currency
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    // If a row is selected, call the getCurrency method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let finalURL = url + currencyArray[row]
        selectedCurrencyIndex = row
        getCurrency(url: finalURL)
    }
    
}

