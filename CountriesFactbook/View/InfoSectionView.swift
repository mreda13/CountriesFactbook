//
//  InfoSectionView.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2020-04-20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import SnapKit

class InfoSectionView: NibView {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    required init() {
        super.init(with: "InfoSectionView", and: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder not initialized")
    }
    
    private func setupView(){
        self.titleView.layer.cornerRadius = 18.0
        self.textView.layer.cornerRadius = 18.0
        
        self.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(100.0)
        }
    }

}
