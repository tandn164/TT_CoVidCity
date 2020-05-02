//
//  DetailSearchPlaceController.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/27/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import GooglePlaces
protocol DetailSearchPlaceControllerDelegate: class {
    func didGetData(from sender: DetailSearchPlaceController, _ locationName: String?, _ lat: Double?, _ lon: Double?)
}
class DetailSearchPlaceController: UIViewController {
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    weak var delegate : DetailSearchPlaceControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        view.backgroundColor = .white
        searchController?.searchBar.sizeToFit()
        searchController?.view.backgroundColor = .white
        searchController?.searchBar.backgroundColor = .white
        searchController?.searchBar.tintColor = .gray
        searchController?.searchBar.searchTextField.backgroundColor = .white
        searchController?.searchBar.searchTextField.textColor = .black
        searchController?.hidesNavigationBarDuringPresentation = false
        resultsViewController?.view.backgroundColor = .white
        resultsViewController?.primaryTextColor = .black
        resultsViewController?.primaryTextHighlightColor = .black
        resultsViewController?.tableCellBackgroundColor = .white
        resultsViewController?.secondaryTextColor = .black
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
    }
}


// Handle the user's selection.
extension DetailSearchPlaceController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        self.delegate?.didGetData(from: self, place.name! + ", " + place.formattedAddress!, place.coordinate.latitude, place.coordinate.longitude)
        self.dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
