//
//  NibView.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2020-04-20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class NibView: UIView {

    @IBOutlet private(set) var contentView: UIView!
    
    init(with nibName: String, and frame: CGRect) {
        super.init(frame: frame)
        self.setupNib(with: nibName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder not implemented")
    }
    
    private func setupNib(with nibName: String){
        let nib = UINib(nibName: nibName, bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }

}
