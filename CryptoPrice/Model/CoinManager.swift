//
//  CoinManager.swift
//  CryptoPrice
//
//  Created by Sergey Borisov on 12.04.2020.
//  Copyright © 2020 Sergey Borisov. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateValue(_ selectedCoin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://min-api.cryptocompare.com/data/price?fsym="
    
    var currentFirstCurrency: String?
    var currentSecondCurrency: String?
    
    let arrayForFirstCurrency = ["BTC","ETH","BCH","BSV","LTC","LINK","BNB","ZEC","ETC","DASH","XLM","EOS","XRP","XTZ","NEO","TRX","MWC","YO","ATOM","HT","SOL","BEAM","DOGE","BTG","XMR"]
    
    let arrayForSecondCurrency = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    mutating func getCoinPrice(for firstCurrency: String, and secondCurrency: String) {
        
        currentFirstCurrency = firstCurrency
        currentSecondCurrency = secondCurrency
        
        let urlForRequest = "\(baseURL)\(firstCurrency)&tsyms=\(secondCurrency)"
        
        performRequest(with: urlForRequest)
    }
    
    func performRequest(with urlString:String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let selectedCoin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateValue(selectedCoin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            let coinValue = getCoinValue(decodedData)
            let coinModel = CoinModel(firstCurrencyLabel: currentFirstCurrency!,
                                      secondCurrencyLabel: currentSecondCurrency!,
                                      currencyValue: coinValue!)
            
            return coinModel
        } catch {
            print(error)
            return nil
        }
    }
    
    func getCoinValue(_ data: CoinData) -> String? {
        
        var coinDataArray: [Double] = [0.0]
        
        if data.AUD != nil { coinDataArray.append(data.AUD!) }
        if data.BRL != nil { coinDataArray.append(data.BRL!) }
        if data.CAD != nil { coinDataArray.append(data.CAD!) }
        if data.CNY != nil { coinDataArray.append(data.CNY!) }
        if data.EUR != nil { coinDataArray.append(data.EUR!) }
        if data.GBP != nil { coinDataArray.append(data.GBP!) }
        if data.HKD != nil { coinDataArray.append(data.HKD!) }
        if data.IDR != nil { coinDataArray.append(data.IDR!) }
        if data.ILS != nil { coinDataArray.append(data.ILS!) }
        if data.INR != nil { coinDataArray.append(data.INR!) }
        if data.JPY != nil { coinDataArray.append(data.JPY!) }
        if data.MXN != nil { coinDataArray.append(data.MXN!) }
        if data.NOK != nil { coinDataArray.append(data.NOK!) }
        if data.NZD != nil { coinDataArray.append(data.NZD!) }
        if data.PLN != nil { coinDataArray.append(data.PLN!) }
        if data.RON != nil { coinDataArray.append(data.RON!) }
        if data.RUB != nil { coinDataArray.append(data.RUB!) }
        if data.SEK != nil { coinDataArray.append(data.SEK!) }
        if data.SGD != nil { coinDataArray.append(data.SGD!) }
        if data.USD != nil { coinDataArray.append(data.USD!) }
        if data.ZAR != nil { coinDataArray.append(data.ZAR!) }
        
        return String(format: "%.3f", coinDataArray[1])
    }
}
