//
//  CurrencyConvertorViewController.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-07-17.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class CurrencyConvertorViewController: UIViewController , UITextFieldDelegate {
    
    var targetCurrency:String?
    private var baseCurrency:String?
    private var rate:Double?
    
    @IBOutlet weak var defaultCurrencyField: UITextField!
    @IBOutlet weak var targetCurrencyField: UITextField!
    @IBOutlet weak var defaultCurrencyLabel: UILabel!
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    @IBOutlet weak var updateCurrencyButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func defaultTextFieldChanged(_ sender: Any) {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let newVal = formatter.number(from: defaultCurrencyField.text ?? "0") ?? 0
        let value = Double(exactly: newVal)! * rate!
        targetCurrencyField.text = "\(value)"
    }
    
    @IBAction func targetTextFieldChanged(_ sender: Any) {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        let newVal = formatter.number(from: targetCurrencyField.text ?? "0") ?? 0
        let value = Double(exactly: newVal)! / rate!
        defaultCurrencyField.text = "\(value)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultCurrencyField.delegate = self
        targetCurrencyField.delegate = self
        
        if  let base = UserDefaults.standard.string(forKey: "PreferredCurrency") {
            defaultCurrencyLabel.text = base
        }
        
        targetCurrencyLabel.text = targetCurrency
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)

        getCurrencyRate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if baseCurrency != nil {
            defaultCurrencyLabel.text = baseCurrency
            getCurrencyRate()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateCurrency" {
            let vc = segue.destination as! DefaultCurrencyViewController
            vc.delegate = self
        }
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    //DELEGATE METHOD
    func pass(data: String) {
        baseCurrency = data
        updateCurrency()
    }
    
    //HELPER METHODS
    func updateCurrency(){
        if baseCurrency != nil {
            defaultCurrencyLabel.text = baseCurrency
            getCurrencyRate()
        }
    }

    func loading(_ loading:Bool){
        if loading {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        defaultCurrencyField.isEnabled = !loading
        targetCurrencyField.isEnabled = !loading
    }
    
    func getCurrencyRate(){
        loading(true)
        if baseCurrency == nil {
            baseCurrency = UserDefaults.standard.string(forKey: "PreferredCurrency")
        }
        if let base=baseCurrency,let target = targetCurrency {
            APIHelper.getCurrencyConversationRates(base: base, target: target) { (data, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.loading(false)
                        let alertController = UIAlertController(title: "Error", message: "Failed to get currency rates. Please try again later.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Dismiss", style: .default)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                guard let data = data else{
                    DispatchQueue.main.async {
                        self.loading(false)
                        let alertController = UIAlertController(title: "Error", message: "No currency rates available. Please try again later.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Dismiss", style: .default)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    return
                }
                self.rate = data
                DispatchQueue.main.async {
                    self.targetCurrencyField.text = "\(self.rate ?? 1)"
                    self.loading(false)
                }
            }
        }
    }
}
