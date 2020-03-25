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


class MapViewController: UIViewController, CLLocationManagerDelegate, GMUClusterManagerDelegate, GMSMapViewDelegate{
  
  private var clusterManager: GMUClusterManager!
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var mapView: GMSMapView!
  var placesClient: GMSPlacesClient!
  var zoomLevel: Float = 15.0
  
  var markers = [GMSMarker]()
  
  // An array to hold the list of likely places.
  var likelyPlaces: [GMSPlace] = []
  
  // The currently selected place.
  var selectedPlace: GMSPlace?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.requestAlwaysAuthorization()
    
    let camera = GMSCameraPosition.camera(withLatitude: 21.0294498,
                                          longitude: 105.8544441,
                                          zoom: 12.5)
    mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
    mapView.settings.myLocationButton = true
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.isMyLocationEnabled = true
    
    // Add the map to the view, hide it until we've got a location update.
    view.addSubview(mapView)
    mapView.isHidden = false
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
    locationManager.delegate = self
    
    placesClient = GMSPlacesClient.shared()
    
    markers.append(addMarker( lat: 20.98498, long:105.841041 , cased: "F0"))
    markers.append(addMarker( lat: 20.9824498, long:105.831041 , cased: "F1"))
    markers.append(addMarker( lat: 20.9794498, long:105.821041 , cased: "New F0"))
    
    // Set up the cluster manager with the supplied icon generator and
    // renderer.
    let iconGenerator = GMUDefaultClusterIconGenerator()
    let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
    let renderer = GMUDefaultClusterRenderer(mapView: mapView,
                                             clusterIconGenerator: iconGenerator)
    clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm,
                                       renderer: renderer)
    
    // Generate and add random items to the cluster manager.
    generateClusterItems()
    
    // Call cluster() after items have been added to perform the clustering
    // and rendering on map.
    clusterManager.cluster()
    
    clusterManager.setDelegate(self, mapDelegate: self)
  }
  // Update the map once the user has made their selection.
  @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    // Clear the map.
    mapView.clear()
    
    markers.append(addMarker( lat: 20.98498, long:105.841041 , cased: "F0"))
    markers.append(addMarker( lat: 20.9824498, long:105.831041 , cased: "F1"))
    markers.append(addMarker( lat: 20.9794498, long:105.821041 , cased: "New F0"))
    
    // Add a marker to the map.
    if selectedPlace != nil {
      let marker = GMSMarker(position: (self.selectedPlace?.coordinate)!)
      marker.title = "You"
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
  func addMarker(lat: Double, long: Double, cased: String) -> GMSMarker{
    let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
    let marker = GMSMarker(position: position)
    marker.title = cased
    marker.map = mapView
    marker.icon = GMSMarker.markerImage(with: caseIdent(title: cased))
    marker.isFlat = true
    return marker
  }
  func caseIdent(title: String) -> UIColor {
    if title == "F0" {
      return .red
    }
    if title == "F1" {
      return .orange
    } else {
      return .white
      
    }
  }
  
  private func generateClusterItems() {
    let extent = 0.2
    for index in 1...10 {
      let lat = 20.977 + extent * randomScale()
      let lng = 105.841 + extent * randomScale()
      let name = "Item \(index)"
      let item = POIItem(position: CLLocationCoordinate2DMake(lat, lng), name: name)
      clusterManager.add(item)
    }
  }
  
  /// Returns a random value between -1.0 and 1.0.
  private func randomScale() -> Double {
    return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
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

extension MapViewController {
  // MARK: - GMUClusterManagerDelegate
  
  func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
    let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                             zoom: mapView.camera.zoom + 1)
    let update = GMSCameraUpdate.setCamera(newCamera)
    mapView.moveCamera(update)
  }
  
  // MARK: - GMUMapViewDelegate
  
  func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
    if let poiItem = marker.userData as? POIItem {
      NSLog("Did tap marker for cluster item \(poiItem.name ?? "")")
    } else {
      NSLog("Did tap a normal marker")
    }
    return false
  }
}


