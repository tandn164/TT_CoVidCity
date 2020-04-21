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
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var lat: Double!
    var long: Double!
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        setViewData()
    }
    func setViewData() {
        let currentUser = Auth.auth().currentUser
        let docRef = db.collection("User").document(currentUser!.uid)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()!
                if let name = data["UserName"] as? String, let address = data["Address"] as? String, let type = data["Type"] as? String//, let lat = data["lat"] as? NSNumber, let lon = data["lon"] as? NSNumber
                {
                    self.nameField.text = name
                    self.addressField.text = address
                    self.typeField.text = type
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    @IBAction func submitPressed(_ sender: UIButton) {
        //TODO
        if isEndEditing(nameField) && isEndEditing(addressField) && isEndEditing(typeField)
        {
            updateUser()
        }
    }
    
    func isEndEditing(_ textField: UITextField) -> Bool{
        if textField.text != "" {
            return true
        } else {
            let alert = UIAlertController(title: "Input somthing pls", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    func updateUser() {
       //TODO
        let user = Auth.auth().currentUser
        if let content = typeField.text, let contentSender = nameField.text, let title = addressField.text, let lat = lat, let long = long {
            let changeRequest = user!.createProfileChangeRequest()
            changeRequest.displayName = contentSender
            changeRequest.commitChanges { (error) in
            }
            db.collection("User").document(user!.uid).setData([
                "UserName": contentSender,
                "Address": title,
                "Type": content,
                "lat": lat,
                "long": long,
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
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
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
