//
//  ViewController.swift
//  BitcoinTracker
//
//  Created by NomNomNam on 2/18/18.
//  Copyright © 2018 NamHNguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var currencySelected = ""
    var finalURL = ""
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var dayBitcoinPriceChangeLabel: UILabel!
    @IBOutlet weak var weekBitcoinPriceChangeLabel: UILabel!
    @IBOutlet weak var monthBitcoinPriceChangeLabel: UILabel!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        currencySelected = currencySymbol[row]
        getBitcoinData(url: finalURL)
    }
    
    func getBitcoinData(url: String){
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                print("Success! Got back Bitcoin data")
                let bitcoinJSON : JSON = JSON(response.result.value!)
                print(bitcoinJSON)
                self.updateBitcoinAveragePrice(json: bitcoinJSON)
                self.updateBitcoinDailyPriceChange(json: bitcoinJSON)
                self.updateBitcoinWeeklyPriceChange(json: bitcoinJSON)
                self.updateBitcoinMonthlyPriceChange(json: bitcoinJSON)
            } else {
                print("Error:\(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateBitcoinAveragePrice(json: JSON) {
        if let bitcoinAveragePrice = json["averages"]["day"].double {
            bitcoinPriceLabel.text = "\(currencySelected)\(bitcoinAveragePrice)"
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
    }

    func updateBitcoinDailyPriceChange(json: JSON) {
        if let bitcoinDailyPriceChange = json["changes"]["price"]["day"].double {
            dayBitcoinPriceChangeLabel.text = "\(currencySelected)\(bitcoinDailyPriceChange)"
        } else {
            dayBitcoinPriceChangeLabel.text = "Price Unavailable"
        }
    }

    func updateBitcoinWeeklyPriceChange(json: JSON) {
        if let bitcoinWeeklyPriceChange = json["changes"]["price"]["week"].double {
            weekBitcoinPriceChangeLabel.text = "\(currencySelected)\(bitcoinWeeklyPriceChange)"
        } else {
            weekBitcoinPriceChangeLabel.text = "Price Unavailable"
        }
    }
    
    func updateBitcoinMonthlyPriceChange(json: JSON) {
        if let bitcoinMonthlyPriceChange = json["changes"]["price"]["month"].double {
            monthBitcoinPriceChangeLabel.text = "\(currencySelected)\(bitcoinMonthlyPriceChange)"
        } else {
            monthBitcoinPriceChangeLabel.text = "Price Unavailable"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

