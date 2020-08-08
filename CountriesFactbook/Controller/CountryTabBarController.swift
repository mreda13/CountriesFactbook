//
//  CountryTabBarController.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2020-05-28.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class CountryTabBarController: UITabBarController {

    var country:Country!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let countryVC = self.viewControllers?[0] as! CountryViewController
        countryVC.country = country
        
        let currencyVC = self.viewControllers?[1] as! CurrencyConvertorViewController
        
        currencyVC.targetCurrency = country.currencyCode
    }
}
