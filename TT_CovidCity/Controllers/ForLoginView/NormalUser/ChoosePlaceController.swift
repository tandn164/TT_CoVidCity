//
//  ChoosePlace.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/26/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsUtils
protocol ChoosePlaceControllerDelegate: class {
    func didGetvisitedLocation(from sender: ChoosePlaceController, _ data: [VisitedLocation])
}
class ChoosePlaceController: UIViewController,CLLocationManagerDelegate,GMUClusterManagerDelegate,GMSMapViewDelegate{
    private var clusterManager: GMUClusterManager!
    var locationManager = CLLocationManager()
    var child = DetailSearchPlaceController()
    var mapView: GMSMapView!
    var findView: SearchView!
    var visitedLocation : [VisitedLocation] = []
    var searchField : UITextField!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var test : String?
    var markers = [GMSMarker]()
    weak var delegate : ChoosePlaceControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubView()
        setLocationManager()
        child.delegate = self
        setMarker()
    }
    func setMarker()  {
        for i in visitedLocation{
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: i.lat!, longitude: i.lon!)
            marker.title = i.locationAddress!
            marker.map = mapView
            markers.append(marker)
        }
    }
    func setSubView() {
        let camera = GMSCameraPosition.camera(withLatitude: 21.0294498, longitude: 105.8544441, zoom: 12)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        searchField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-20, height: 45.0))
        searchField.addTarget(self, action: #selector(myTargetFunction(textField:)), for: .touchDown)
        searchField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        findView = SearchView(frame: CGRect(x: 10, y: 100, width: self.view.frame.width-20, height: 45.0))
        findView.addSubview(searchField)
        self.view = mapView
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        self.view.addSubview(findView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done!", style: .plain, target: self, action: #selector(donePressed(_:)))
        
    }
    @objc func myTargetFunction(textField: UITextField) {
        self.present(child, animated: true, completion: nil)
    }
    func setLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    // MARK: - GMUClusterManagerDelegate
    func clusterManager(_ clusterManager: GMUClusterManager, didTap cluster: GMUCluster) -> Bool {
        let newCamera = GMSCameraPosition.camera(withTarget: cluster.position,
                                                 zoom: mapView.camera.zoom + 1)
        let update = GMSCameraUpdate.setCamera(newCamera)
        mapView.moveCamera(update)
        return false
    }
    @objc func donePressed(_ sender: UIBarButtonItem)
    {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        self.delegate?.didGetvisitedLocation(from: self, visitedLocation)
    }
    
}
extension ChoosePlaceController {
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
    
}
extension ChoosePlaceController : DetailSearchPlaceControllerDelegate{
    func didGetData(from sender: DetailSearchPlaceController, _ locationName: String?, _ lat: Double?, _ lon: Double?) {
        self.visitedLocation.append(VisitedLocation(locationAddress: locationName, lat: lat, lon: lon))
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        marker.title = locationName!
        marker.map = mapView
        let location = GMSCameraPosition.camera(withLatitude: lat!, longitude: lon!, zoom: 17.0)
        mapView.camera = location
        markers.append(marker)
    }
    
    
}

