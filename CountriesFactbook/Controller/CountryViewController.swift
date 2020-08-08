//
//  CountryViewController.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-06-15.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

class CountryViewController: UIViewController {
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackContainerView: UIView!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    var country:Country!
    var fullName:String?
    var nativeName:String?
    var capital:String?
    var population:Int64?
    var languages:[String]?
    var currencyCode:String?
    var currencyName:String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSetup()
        setupText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = country.commonName!

    }
    
    @IBAction func moreInfoPressed(_ sender: Any) {
        //TODO: ADD ERROR WHEN NO INTERNET
        var name = country.name
        switch name {
        case "Korea (Democratic People's Republic of)":
            name = "North Korea"
        case "Congo":
            name = "Congo-Brazzaville"
        case "Ireland":
            name = "Republic of Ireland"
        case "Georgia":
            name = "Georgia country"
        default:
            break
        }

        let encodedName = name?.replacingOccurrences(of: " ", with: "_").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(encodedName!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    //MARK:  - Helper Methods
    
    func formattedNumericString(number:Int64) -> String?{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:number))
        return formattedNumber
    }
    
    func layoutSetup(){
        flagImage.image = UIImage(named: country.commonName!)
        flagImage.layer.borderWidth = 1.0

        if let fN = country.fullName ,
            let nN = country.nativeName,
            let capitalCity = country.capital,
            let langs = country.languages ,
            let cC = country.currencyCode,
            let cN = country.currencyName
        {
            fullName = fN == "" ? country.name : fN
            nativeName = nN
            languages = langs
            currencyName = cN
            currencyCode = cC
            capital = capitalCity
            population = country.population
        }
        moreInfoButton.layer.cornerRadius = 18
        stackContainerView.layer.cornerRadius = 18.0
    }
        
    func setupText(){
        for i in 0...5 {
            let view = InfoSectionView()
            var title:String
            var text = ""
            switch i {
                case 0:
                    title = "Full Name"
                    text = fullName ?? ""
                case 1:
                    title = "Native Name"
                    text = nativeName ?? ""
                case 2:
                    title = "Capital City"
                    text = capital ?? ""
                case 3:
                    title = "Population"
                    text = formattedNumericString(number: population ?? 0) ?? ""
                case 4:
                    title = "Languages"
                    if let languages = languages {
                        for lang in languages {
                            text += "\(lang), "
                        }
                        text.removeLast(2)
                    }
                case 5:
                    title = "Currency"
                    text = "\(currencyName ?? "N/A") (\(currencyCode ?? "N/A"))"
                default:
                    title = "N/A"
                    text = "N/A"
            }
            
            view.titleLabel.text = title
            view.textLabel.text = text
            
            stackView.addArrangedSubview(view)
            
            view.contentView.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
        self.stackContainerView.snp.remakeConstraints { (make) in
            make.height.equalTo(self.stackView.snp.height)
        }
    }
}
