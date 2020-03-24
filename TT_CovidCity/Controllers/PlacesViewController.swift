//
//  PlacesViewController.swift
//  TT_CovidCity
//
//  Created by Trần Nhất Thống on 3/24/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class PlacesViewController: UITableViewController {
  
  // An array to hold the list of likely places.
  var likelyPlaces: [GMSPlace] = []
  
  // The currently selected place.
  var selectedPlace: GMSPlace?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "unwindToMain" {
      if let nextViewController = segue.destination as? MapViewController {
        nextViewController.selectedPlace = selectedPlace
      }
    }
  }
  
  
}
// Populate the table with the list of most likely places.
extension PlacesViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return likelyPlaces.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier",
                                             for: indexPath)
    let collectionItem = likelyPlaces[indexPath.row]
    
    cell.textLabel?.text = collectionItem.name
    
    return cell
  }
  
  // Show only the first five items in the table (scrolling is disabled in IB).
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.size.height/5
  }
  
  // Make table rows display at proper height if there are less than 5 items.
  override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if (section == tableView.numberOfSections - 1) {
      return 1
    }
    return 0
  }
}

extension PlacesViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedPlace = likelyPlaces[indexPath.row]
    performSegue(withIdentifier: "unwindToMain", sender: self)
  }
}
