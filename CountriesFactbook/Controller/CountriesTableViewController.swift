//
//  CountriesTableViewController.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-06-15.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import CoreData

class CountriesTableViewController: UITableViewController {
    
    var countriesArray:[String] = []
    var filteredCountries:[String] = []
    var countries:[(key: String, value: [String])] = []
    var country = Country(context: DataController.shared.viewContext)
    var selectedIndexPath:IndexPath?
    
    let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCountries()
        setupSearch()
        tableView.delegate = self
        tableView.reloadData()
    }
    
    //MARK: - Helper methods
    
    func setupCountries(){
        countriesArray = UserDefaults.standard.stringArray(forKey: "countriesArray") ?? CountriesAPIHelper.getCountryNames()
        countriesArray.sort()
        var countriesDictionary:[String:[String]] = [:]
        let dict = Dictionary.init(grouping: countriesArray, by:{String($0.prefix(1))})
        let keys = dict.keys.sorted()
        for key in keys.sorted() {
            countriesDictionary[key] = dict[key]
        }
        countries = countriesDictionary.sorted(by: { $0.0 < $1.0 })
    }
    
    func setupSearch(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func filterContent(_ searchText: String) {
        filteredCountries = countriesArray.filter { (name: String) -> Bool in
                return name.lowercased().contains(searchText.lowercased())
        }
        filteredCountries.sort()
        tableView.reloadData()
    }
    
    func getCountryFromStorage(_ name:String)->Country? {
        var country:Country?
        let fetchRequest:NSFetchRequest<Country> = Country.fetchRequest()
        let predicate:NSPredicate = NSPredicate(format: "name=%@", argumentArray: [name])
        fetchRequest.predicate = predicate
        do{
            let results = try DataController.shared.viewContext.fetch(fetchRequest)
            if results.count > 0 {
                country = results[0]
            }
        }
        catch{
            print(error)
        }
        return country
    }
    
    func getCountryInfo(_ name:String){
        let cell = tableView.cellForRow(at: selectedIndexPath!) as! CountriesTableViewCell
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        if let result = getCountryFromStorage(name) {
            cell.activityIndicator.isHidden = true
            //print("found country")
            country = result
            self.setupDataForSegue()
        }
        else{
            APIHelper.getCountryInfo(name: name) { (countryResponse, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        let alertController = UIAlertController(title: "Error", message: "Failed to get data. Please try again.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Dismiss", style: .default)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    return
                }
                guard let data = countryResponse else
                {
                    DispatchQueue.main.async {
                        cell.activityIndicator.stopAnimating()
                        cell.activityIndicator.isHidden = true
                        let alertController = UIAlertController(title: "Error", message: "Country data not available", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Dismiss", style: .default)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.country.name = data.name
                    self.country.capital = data.capital
                    self.country.currencyName = data.currencies[0].name
                    self.country.currencyCode = data.currencies[0].code
                    self.country.fullName = CountriesAPIHelper.getOfficialName(data.name)
                    self.country.nativeName = data.nativeName
                    self.country.population = data.population
                    var languages:[String] = []
                    for language in data.languages {
                        languages.append(language.name)
                    }
                    self.country.languages = languages
                    
                    do{
                        try DataController.shared.viewContext.save()
                    }
                    catch{
                        print(error)
                    }
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                    self.setupDataForSegue()
                }
            }
        }
    }
    
    func setupDataForSegue(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        vc.country = country
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UITableView data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return 1
        }
        else{
            return countries.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCountries.count
        }
        else {
            return countries[section].value.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return nil
        }
        else{
            return countries[section].key
        }
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering{
            return nil
        }
        
        var sections:[String] = []
        for index in 0...(countries.count-1) {
            sections.append(countries[index].key)
        }
        return sections
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CountriesTableViewCell
        let countryName:String
        if isFiltering{
            
            countryName = filteredCountries[indexPath.row]
        }
        else{
            countryName = countries[indexPath.section].value[indexPath.row]
        }
        cell.countryName.text = countryName
        cell.flagIcon.image = UIImage(named: countryName)
        cell.activityIndicator.isHidden = true
        return cell
    }
    
    //MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        var name:String
        if isFiltering {
            name = filteredCountries[indexPath.row]
        }
        else{
            name = countries[indexPath.section].value[indexPath.row]
        }
        country.commonName = name
        //For the below country names, different names are required for the API to return the proper data for the country
        switch name {
        case "North Korea":
            name = "Korea (Democratic People's Republic of)"
        case "South Korea":
            name = "Korea (Republic of)"
        case "Republic of the Congo":
            name = "Congo-Brazzaville"
        case "North Macedonia":
            name = "Macedonia"
        case "Sudan":
            name = "Republic of the Sudan"
        default:
            break;
        }

        getCountryInfo(name)
    }
}

//MARK: EXTENSION

extension CountriesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContent(searchBar.text!)
    }
}
