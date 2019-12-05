//
//  DefaultCurrencyViewController.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-06-21.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class DefaultCurrencyViewController: UIViewController, UIPickerViewDelegate ,UIPickerViewDataSource {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var button: UIButton!
    
    var selectedCurrency:String?
    var delegate:CurrencyConvertorViewController?
    
    let currencyCodes = ["AED", "AFN", "ALL", "AMD", "ANG", "AOA", "ARS", "AUD", "AWG", "AZN", "BAM", "BBD", "BDT", "BGN", "BHD", "BIF", "BMD", "BND", "BOB", "BOV", "BRL", "BSD", "BTN", "BWP", "BYR", "BZD", "CAD", "CDF", "CHE", "CHF", "CHW", "CLF", "CLP", "CNY", "COP", "COU", "CRC", "CUC", "CUP", "CVE", "CZK", "DJF", "DKK", "DOP", "DZD", "EGP", "ERN", "ETB", "EUR", "FJD", "FKP", "GBP", "GEL", "GHS", "GIP", "GMD", "GNF", "GTQ", "GYD", "HKD", "HNL", "HRK", "HTG", "HUF", "IDR", "ILS", "INR", "IQD", "IRR", "ISK", "JMD", "JOD", "JPY", "KES", "KGS", "KHR", "KMF", "KPW", "KRW", "KWD", "KYD", "KZT", "LAK", "LBP", "LKR", "LRD", "LSL", "LTL", "LVL", "LYD", "MAD", "MDL", "MGA", "MKD", "MMK", "MNT", "MOP", "MRO", "MUR", "MVR", "MWK", "MXN", "MXV", "MYR", "MZN", "NAD", "NGN", "NIO", "NOK", "NPR", "NZD", "OMR", "PAB", "PEN", "PGK", "PHP", "PKR", "PLN", "PYG", "QAR", "RON", "RSD", "RUB", "RWF", "SAR", "SBD", "SCR", "SDG", "SEK", "SGD", "SHP", "SLL", "SOS", "SRD", "SSP", "STD", "SYP", "SZL", "THB", "TJS", "TMT", "TND", "TOP", "TRY", "TTD", "TWD", "TZS", "UAH", "UGX", "USD", "USN", "USS", "UYI", "UYU", "UZS", "VEF", "VND", "VUV", "WST","YER", "ZAR", "ZMW"];
    
    var baseCurrency:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseCurrency = currencyCodes[0]
        if UserDefaults.standard.string(forKey: "PreferredCurrency") == nil {
            UserDefaults.standard.set(currencyCodes[0], forKey: "PreferredCurrency")
        }
        currencyPicker.delegate = self
        currencyPicker.layer.backgroundColor = UIColor.white.cgColor
        currencyPicker.layer.borderColor = UIColor.black.cgColor
        currencyPicker.layer.borderWidth = 2.0
        currencyPicker.layer.cornerRadius = 4.0
        button.layer.cornerRadius = 4.0
        
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore"){
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    @IBAction func setDefaultCurrency(_ sender: Any) {
        if !UserDefaults.standard.bool(forKey: "didSetCurrency") {
            UserDefaults.standard.set(true, forKey: "didSetCurrency")
            let alertController = UIAlertController(title: "Done!", message: "You're all set! Press next to start using the app.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Next", style: .default) { (_) in
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountriesTableViewController") as! CountriesTableViewController
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
        }
        else {
            self.dismiss(animated: true, completion: {
                self.delegate?.pass(data: self.baseCurrency ?? "AED")
                UserDefaults.standard.set(self.baseCurrency, forKey: "PreferredCurrency")
            })
        }
    }
    
    //MARK: DATA SOURCE METHOD
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCodes.count
    }

    //MARK: DELEGATE METHODS
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        baseCurrency = currencyCodes[row]        
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let text = currencyCodes[row]
        
        let title = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        return title
    }
}

