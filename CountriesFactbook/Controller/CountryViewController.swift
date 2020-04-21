//
//  CountryViewController.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-06-15.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

class CountryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var titleNavItem: UINavigationItem!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currConverterButton: UIButton!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currencyConvertor" {
            let vc = segue.destination as! CurrencyConvertorViewController
            vc.targetCurrency = currencyCode
        }
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
        flagImage.image = UIImage(named: country.name!)
        flagImage.layer.borderWidth = 1.0
        titleNavItem.title = country.commonName!
        titleNavItem.rightBarButtonItem?.title = "test"

        if let fN = country.fullName , let nN = country.nativeName, let capitalCity = country.capital, let langs = country.languages , let cC = country.currencyCode, let cN = country.currencyName{
            if fN == "" {
                fullName = country.name
            }
            else{
                fullName = fN
            }
            nativeName = nN
            languages = langs
            currencyName = cN
            currencyCode = cC
            capital = capitalCity
            population = country.population
            
        }
        buttonSetup(currConverterButton)
        buttonSetup(moreInfoButton)
    }
    
    func buttonSetup(_ button:UIButton){
        button.layer.cornerRadius = 18
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
            view.sectionTitle.text = title
            view.sectionText.text = text
            
            stackView.addArrangedSubview(view)
            
            view.contentView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
        }
    }
    
    //MARK: - UITableView data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 4 {
            if let x = country.languages {
                return x.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var header:String?
        
        switch section {
        case 0:
            header = "Full Name"
        case 1:
            header = "Native Name"
        case 2:
            header = "Capital City"
        case 3:
            header = "Population"
        case 4:
            header = "Languages"
        case 5:
            header = "Currency"
        default:
            header = "N/A"
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = fullName
        case 1:
            cell.textLabel?.text = nativeName
        case 2:
            cell.textLabel?.text = capital
        case 3:
            cell.textLabel?.text = formattedNumericString(number: population ?? 0)
        case 4:
            cell.textLabel?.text = languages?[indexPath.row]
        case 5:
            cell.textLabel?.text = "\(currencyName ?? "N/A") (\(currencyCode ?? "N/A"))"
        default:
            cell.textLabel?.text = "N/A"
        }
        return cell
    }
}
