//
//  ViewController.swift
//  CryptoPrice
//
//  Created by Sergey Borisov on 12.04.2020.
//  Copyright © 2020 Sergey Borisov. All rights reserved.
//

import UIKit

class CryptoViewController: UIViewController {
    
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    
    @IBOutlet weak var currencyValue: UILabel!
    
    @IBOutlet weak var firstCurrencyPicker: UIPickerView!
    @IBOutlet weak var secondCurrencyPicker: UIPickerView!
    
    var selectedFirstCurrency: String?
    var selectedSecondCurrency: String?
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstCurrencyPicker.dataSource = self
        secondCurrencyPicker.dataSource = self
        
        firstCurrencyPicker.delegate = self
        secondCurrencyPicker.delegate = self
        
        coinManager.delegate = self
    }
}

//MARK: - UIPickerViewDataSource
extension CryptoViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == firstCurrencyPicker {
            return coinManager.arrayForFirstCurrency.count
        } else {
            return coinManager.arrayForSecondCurrency.count
        }
    }
}

//MARK: - UIPickerViewDelegate
extension CryptoViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == firstCurrencyPicker {
            return coinManager.arrayForFirstCurrency[row]
        } else {
            return coinManager.arrayForSecondCurrency[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == firstCurrencyPicker {
            selectedFirstCurrency = coinManager.arrayForFirstCurrency[row]
        } else {
            selectedSecondCurrency = coinManager.arrayForSecondCurrency[row]
        }
        
        coinManager.getCoinPrice(for: selectedFirstCurrency ?? "BTC", and: selectedSecondCurrency ?? "AUD")
    }
}

//MARK: - CoinManagerDelegate
extension CryptoViewController: CoinManagerDelegate {
    
    func didUpdateValue(_ selectedCoin: CoinModel) {
        
        DispatchQueue.main.async {
            self.firstCurrencyLabel.text = selectedCoin.firstCurrencyLabel
            self.currencyValue.text = selectedCoin.currencyValue
            self.secondCurrencyLabel.text = selectedCoin.secondCurrencyLabel
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
