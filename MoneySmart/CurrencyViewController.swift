//
//  CurrencyViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 26/1/21.
//

import Foundation
import UIKit

class CurrencyViewController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    
    @IBOutlet weak var money: UITextField!
    @IBOutlet weak var pickerview: UIPickerView!
    @IBOutlet weak var pricelbl: UILabel!
    
    var currenctyCode: [String] = []
    var values:[ Double] = []
    var activeCurrency = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJson()
        pickerview.delegate = self
        pickerview.dataSource = self
        money.addTarget(self, action: #selector(updateViews), for: .editingChanged)
        
        
        
    }
    @objc func updateViews(input:Double)
    {
        guard let amountText = money.text , let theAmountText = Double(amountText) else {return}
        if money.text != ""
        {
            let total = theAmountText/1.33 * activeCurrency
            pricelbl.text = String(format: "%.2f", total)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currenctyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currenctyCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = values[row]
        updateViews(input: activeCurrency)
    }
    
    func fetchJson() {
        do {
            guard let url = URL(string: "https://open.exchangerate-api.com/v6/latest") else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                }
                
                guard let safedata = data else {return}
                
                do
                {
                    let result = try JSONDecoder().decode(ExchangeRates.self, from: safedata)
                    let sgd = Double(result.rates["SGD"]!)
                    self.currenctyCode.append(contentsOf: result.rates.keys)
                    self.values.append(contentsOf: result.rates.values)
                    DispatchQueue.main.async {
                        self.pickerview.reloadAllComponents()
                    }
                }catch{
                    print(error)
                }
            }.resume()
        }
    }
    
    

    
    
    
}
