//
//  APIHelper.swift
//  CountriesFactbook
//
//  Created by Mohamed Metwaly on 2019-06-15.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation

class APIHelper {
    
    static let baseURL = "https://restcountries.eu/rest/v2/"
    
    enum Endpoints {
        
        case getCountryInfo(country:String)
        case getCurrencyRates(base:String,target:String)
        
        var stringValue:String {
            switch self {
            case .getCountryInfo(let country):
                var URL = baseURL + "name/\(country)"
                URL = URL + "?fields=name;capital;currencies;altSpellings;population;nativeName;languages"
                //print(URL)
                return URL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? URL
            case .getCurrencyRates(let base, let target):
                let URL = "https://free.currconv.com/api/v7/convert?q=\(base)_\(target)&compact=ultra&apiKey=7f86ba31914025ba57dd"
                //print(URL)
                return URL
            }
        }
        
        var url: URL {
            return URL(string:stringValue)!
        }
    }
    
    class func taskForGetRequest(request:URLRequest, completion: @escaping (Data?,URLResponse?,Error?)-> Void){
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil,response,error)
                return
            }
            guard let data = data else {
                completion(nil,response,nil)
                return
            }
            completion(data,response,nil)
        }
        task.resume()
    }
    
    class func getCurrencyConversationRates(base:String,target:String,completion: @escaping (Double?,Error?)->Void){
        
        let request = URLRequest(url: APIHelper.Endpoints.getCurrencyRates(base:base,target: target ).url)
        
        //print("getting called")
        taskForGetRequest(request: request) { (data, response, error) in
            if error != nil {
                completion(nil,error!)
                //print("got error")
                return
            }
            guard let data = data else {
                completion(nil,nil)
                return
            }
            
            do {
                let dict:[String:Double] = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Double]
                completion(dict.first?.value,nil)
            }
            catch {
                //print(error)
                completion(nil,error)
                return
            }
        }
        
    }
    
    class func getCountryInfo(name:String,completion: @escaping (CountryResponse?,Error?)->Void){
        
        let request = URLRequest(url: APIHelper.Endpoints.getCountryInfo(country: name).url)
        
        taskForGetRequest(request: request) { (data, response, error) in
            if let error = error {
                //print(error)
                completion(nil,error)
                return
            }
            
            guard let data=data else {
                completion(nil,nil)
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let jsonData = try decoder.decode(Array<CountryResponse>.self, from: data)
                //print(jsonData)
                if name == "India" || name == "United States"{
                    completion(jsonData[1],nil)
                    return
                }
                
                completion(jsonData[0],nil)
                
            }
            catch{
                //print(error)
                completion(nil,error)
            }
        }
    }
}
