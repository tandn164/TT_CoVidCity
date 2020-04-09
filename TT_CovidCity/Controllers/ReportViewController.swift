//
//  FourViewController.swift
//  abc
//
//  Created by Trần Nhất Thống on 3/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation


class ReportViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
  
  @IBOutlet weak var nameField: UITextField!
  @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var contentField: UITextView!
  
  var locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var lat: Double!
  var long: Double!
  
  let db = Firestore.firestore()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentField.delegate = self
    
    locationManager.requestAlwaysAuthorization()
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
    locationManager.delegate = self
  }
  
  @IBAction func submitPressed(_ sender: UIButton) {
    contentField.endEditing(true)
  }
  func textViewShouldReturn(_ textView: UITextView) -> Bool {
    contentField.endEditing(true)
    return true
  }
  
  func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    if textView.text != "" {
      return true
    } else {
      let alert = UIAlertController(title: "Input somthing pls", message: "", preferredStyle: .alert)
      let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
      return false
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if let content = contentField.text, let contentSender = Auth.auth().currentUser?.email, let title = titleField.text, let lat = lat, let long = long {
      db.collection("Report").addDocument(data: [
        "sender": contentSender,
        "title": title,
        "content": content,
        "lat": lat,
        "long": long,
        "date": Date().timeIntervalSince1970
      ]) { (error) in
        if let err = error {
          print(err)
        } else {
          let alert = UIAlertController(title: "Submitted", message: "Thank you for the submition, ありがとうございます。", preferredStyle: .alert)
          let action = UIAlertAction(title: "Done", style: .default) { (action) in
          }
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
        }
      }
    }
  }
}
extension ReportViewController {
  
  // Handle incoming location events.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location: CLLocation = locations.last!
    lat = location.coordinate.latitude
    long = location.coordinate.longitude
  }
  
  // Handle authorization for the location manager.
  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted:
      print("Location access was restricted.")
    case .denied:
      print("User denied access to location.")
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
