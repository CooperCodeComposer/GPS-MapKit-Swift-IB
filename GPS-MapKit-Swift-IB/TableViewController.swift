//
//  TableViewController.swift
//  GPS-MapKit-Swift-IB
//
//  Created by Alistair Cooper on 6/1/16.
//  Copyright © 2016 Alistair Cooper. All rights reserved.
//

import UIKit
import CoreLocation

class TableViewController: UITableViewController {
    
    let restaurantCatArray = ["Cafe", "Pizza", "Thai"]  // array of restaurant categories
    var restaurantArray = [[String:String]]()
    
    let jsonURL = "https://s3-us-west-2.amazonaws.com/uclaiosclass/restaurants.json"
    
    // struct to store strings used in storyboard
    fileprivate struct Storyboard {
        static let cellIdentifier = "RestaurantCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadRestaurants()
    }
    
    func downloadRestaurants() {
        
        // start network pinwheel
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        guard let url = URL(string: jsonURL) else {
            print("Error with json url")
            return
        }
        
        URLSession.shared.dataTask(with:url, completionHandler: { (data, response, error) in
            
            guard let data = data, error == nil else {
                print(error as! NSError)
                return
            }
            
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String : String]] {
                    
                    self.restaurantArray = array
                    
                    DispatchQueue.main.sync() {
                        self.tableView.reloadData()
                        
                        // stop network pinwheel
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                    }
                    
                }
                
            } catch let error as NSError {
                print(error)
                self.showError()
            }
            
        }).resume()
        
    }
    
    func showError() {
        
        let ac = UIAlertController(title: "Loading Error", message: "Could not download restaurant data.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
        
    }

// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return restaurantCatArray.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return restaurantCatArray[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionCatTitle = restaurantCatArray[section]
        
        let filteredArray = restaurantArray.filter({
            
            $0["category"] == sectionCatTitle //access the value to filter
        })

        return filteredArray.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIdentifier, for: indexPath)
        
        // gets category title from array using section as index
        let sectionCatTitle = restaurantCatArray[indexPath.section]
        
        let filteredArray = restaurantArray.filter({
            
            $0["category"] == sectionCatTitle //access the value to filter
        })
        
        // make a dictionary of just object at index path
        let restDict: Dictionary = filteredArray[indexPath.row]
        
        cell.textLabel?.text = restDict["name"]
        cell.detailTextLabel?.text = restDict["price"]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMapSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! MapViewController
                
                // gets category title from array using section as index
                let sectionCatTitle = restaurantCatArray[indexPath.section]
                
                let filteredArray = restaurantArray.filter({
                    
                    $0["category"] == sectionCatTitle //access the value to filter
                })
                
                // make a dictionary of just object at index path
                let restDict: Dictionary = filteredArray[indexPath.row]
                
                // assign selected restaurant lat and lon
                
                guard let latString = restDict["yLoc"], let longString = restDict["xLoc"] else { return }
                
                controller.restLat = Double(latString)!
                controller.restLon = Double(longString)!
                controller.restTitle = restDict["name"]

            }
        }
    }

}
