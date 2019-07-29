//
//  CountryResponse.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-06-15.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

struct CountryResponse: Codable {
    let name:String
    let capital: String
    let currencies:[Currency]
    let languages:[Language]
    let altSpellings:[String]
    let population:Int64
    let nativeName: String
}
