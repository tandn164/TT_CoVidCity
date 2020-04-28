//
//  FirstViewController.swift
//  abc
//
//  Created by Trần Nhất Thống on 3/22/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils


class MapViewController: UIViewController, GMSAutocompleteViewControllerDelegate,
CLLocationManagerDelegate,
GMUClusterManagerDelegate,
GMSMapViewDelegate{
  @IBAction func searchPressed(_ sender: UIBarButtonItem) {
    let autocompleteController = GMSAutocompleteViewController()
    autocompleteController.delegate = self

    // Specify the place data types to return.
    let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
      UInt(GMSPlaceField.placeID.rawValue))!
    autocompleteController.placeFields = fields

    // Specify a filter.
    let filter = GMSAutocompleteFilter()
    filter.type = .address
    autocompleteController.autocompleteFilter = filter

    // Display the autocomplete view controller.
    present(autocompleteController, animated: true, completion: nil)
  }
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(place.name ?? "")")
    print("Place ID: \(place.placeID ?? "")")
    print("Place attributions: \(String(describing: place.attributions))")
    dismiss(animated: true, completion: nil)
  }
  
  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("Error: ", error.localizedDescription)
  }
  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
  
  
  
  let kClusterItemCount = 10000
  let kCameraLatitude = 20.98498
  let kCameraLongitude = 105.841041
  
  private var clusterManager: GMUClusterManager!
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var mapView: GMSMapView!
  var placesClient: GMSPlacesClient!
  var zoomLevel: Float = 15.0
  var number = 0
  
  var markers = [GMSMarker]()
  
  // An array to hold the list of likely places.
  var likelyPlaces: [GMSPlace] = []
  
  // The currently selected place.
  var selectedPlace: GMSPlace?
  
  override func loadView() {
    
    let camera = GMSCameraPosition.camera(withLatitude: 21.0294498,
                                          longitude: 105.8544441, zoom: 12)
    mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    self.view = mapView
    mapView.settings.myLocationButton = true
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.isMyLocationEnabled = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.requestAlwaysAuthorization()
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
    locationManager.delegate = self
    
    placesClient = GMSPlacesClient.shared()
    // Set up the cluster manager with the supplied icon generator and
    // renderer.
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                             clusterIconGenerator: iconGenerator)
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                       renderer: renderer)
    generateClusterItems()
    
    // Call cluster() after items have been added to perform the clustering
    // and rendering on map.
    clusterManager.cluster()
    
    clusterManager.setDelegate(self, mapDelegate: self)
    
    
  }
  // MARK: - Private
  
  /// Randomly generates cluster items within some extent of the camera and adds them to the
  /// cluster manager.
  private func generateClusterItems() {
    let extent = 0.2
    let array = ["F0","F1","New F0"]
    for _ in 1...kClusterItemCount {
      let lat = kCameraLatitude + extent * randomScale()
      let lng = kCameraLongitude + extent * randomScale()
      let name = array.randomElement() ?? ""
      let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
      clusterManager.add(item)
    }
  }
  
  /// Returns a random value between -1.0 and 1.0.
  private func randomScale() -> Double {
    return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
  }
  // Update the map once the user has made their selection.
  @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    
    // Add a marker to the map.
    if selectedPlace != nil {
      number += 1
      let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
      marker.title = "You\(number)"
      marker.snippet = selectedPlace?.formattedAddress
      marker.map = mapView
      marker.icon = GMSMarker.markerImage(with: .black)
    }
    
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "segueToSelect" {
      if let nextViewController = segue.destination as? PlacesViewController {
        nextViewController.likelyPlaces = likelyPlaces
      }
    }
  }
  // MARK: - GMUClusterManagerDelegate
  
  func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
    let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                             zoom: mapView.camera.zoom + 1)
    let update = GMSCameraUpdate.setCamera(newCamera)
    mapView.moveCamera(update)
    return false
  }
  
  // MARK: - GMUMapViewDelegate
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    if let poiItem = marker.userData as? POIItem {
      let alert = UIAlertController(title: (poiItem.name ?? ""), message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Done", style: .default) { (action) in
      }
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    } else {
      NSLog("Did tap a normal marker")
    }
    return false
  }
}	

extension MapViewController {
  
  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    print("Location: \(location)")
    
    let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                          longitude: location.coordinate.longitude,
                                          zoom: zoomLevel)
    
    if mapView.isHidden == true {
      mapView.isHidden = false
      mapView.camera = camera
    } else {
      mapView.animate(to: camera)
    }
    
    listLikelyPlaces()
  }
  
  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
      // Display the map using the default location.
      mapView.isHidden = false
    case .notDetermined:
      print("Location status not determined.")
    case .authorizedAlways: fallthrough
    case .authorizedWhenInUse:
      print("Location status is OK.")
    @unknown default:
      print(Error.self)
    }
  }
  
  // Handle location manager errors.
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationManager.stopUpdatingLocation()
    print("Error: \(error)")
  }
  // Populate the array with the list of likely places.
  func listLikelyPlaces() {
    // Clean up from previous sessions.
    likelyPlaces.removeAll()
    
    placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
      if let error = error {
        // TODO: Handle the error.
        print("Current Place error: \(error.localizedDescription)")
        return
      }
      
      // Get likely places and add to the list.
      if let likelihoodList = placeLikelihoods {
        for likelihood in likelihoodList.likelihoods {
          let place = likelihood.place
          self.likelyPlaces.append(place)
        }
        self.performSegue(withIdentifier: "segueToSelect", sender: self)
      }
    })
  }
}


