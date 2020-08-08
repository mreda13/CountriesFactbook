//
//  CountriesTableViewCell.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-07-20.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {

    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
