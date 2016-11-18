//
//  JsonBuilder.swift
//  GPS-MapKit-Swift-IB
//
//  Created by Alistair Cooper on 6/1/16.
//  Copyright © 2016 Alistair Cooper. All rights reserved.
//

import Foundation

struct JsonBuilder {
    
    static func makeRestaurantArray() -> [[String : String]] {
        
        var restaurantArray: [[String : String]] = []
        
        let restaurant1: [String: String] = ["name": "Lidos", "category": "Pizza", "yLoc": "34.186438", "xLoc": "-118.465329", "price": "$"]
        
        restaurantArray.append(restaurant1)
        
        let restaurant2: [String: String] = ["name": "Kinnara", "category": "Thai", "yLoc": "34.201536", "xLoc": "-118.468155", "price": "$$"]
        
        restaurantArray.append(restaurant2)
        
        let restaurant3: [String: String] = ["name": "Humble Bee Bakery", "category": "Cafe", "yLoc": "34.208744", "xLoc": "-118.510641", "price": "$$"]
        
        restaurantArray.append(restaurant3)
        
        let restaurant4: [String: String] = ["name": "Pizza Rev", "category": "Pizza", "yLoc": "34.1752513", "xLoc": "-118.448375", "price": "$"]
        
        restaurantArray.append(restaurant4)
        
        let restaurant5: [String: String] = ["name": "Napoli's Pizza Kitchen", "category": "Pizza", "yLoc": "34.172339", "xLoc": "-118.456431", "price": "$"]
        
        restaurantArray.append(restaurant5)
        
        let restaurant6: [String: String] = ["name": "Creme Caramel", "category": "Cafe", "yLoc": "34.172316", "xLoc": "-118.456960", "price": "$$$"]
        
        restaurantArray.append(restaurant6)
        
        let restaurant7: [String: String] = ["name": "Midici Neapolitan Pizza", "category": "Pizza", "yLoc": "34.151150", "xLoc": "-118.451412", "price": "$$$"]
        
        restaurantArray.append(restaurant7)
        
        return restaurantArray
        
    }
    
    
    static func JSONStringify(jsonObject: AnyObject, prettyPrinted:Bool = false) -> String? {
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        
        if JSONSerialization.isValidJSONObject(jsonObject) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                
                print("error")
                //Access error here
            }
            
        }
        
        return nil
        
    }
    

}
