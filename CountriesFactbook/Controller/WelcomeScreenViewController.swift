//
//  WelcomeScreenViewController.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-06-23.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {

    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 4.0
    }
}
