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

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var sectionText: UILabel!
    
    required init() {
        super.init(with: "InfoSectionView", and: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder not initialized")
    }
    
    private func setupView(){
        self.backgroundColor = .white
        self.snp.makeConstraints { (make) in
            make.height.equalTo(55.0)
        }
    }
}
