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
//import FirebaseStorage

class ReportViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var image : UIImage?
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var lat: Double!
    var long: Double!
    var userManager : SingleUserManager?
    var currentuser : User?
    let db = Firestore.firestore()
    var photoURL : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
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
        userManager = SingleUserManager((Auth.auth().currentUser?.email)!)
        userManager?.delegate = self
        userManager?.loadData()
        
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
        print(73)
        //push profile image
        image = profileImage.image
        guard let imageSelected = image else {
            print("Image is null")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let storageRef = Storage.storage().reference(forURL: "gs://covidcity-1585012064634.appspot.com/")
        let storageProfileRef = storageRef.child("profile").child((user?.email)!)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metaData) { (storage, err) in
            if let err = err {
                print(err)
                return
            }else{
                
                storageProfileRef.downloadURL { (url, err) in
                    self.photoURL = url?.absoluteString
                    if let type = self.typeField.text, let userName = self.nameField.text, let address = self.addressField.text{
                        print(85)
                        self.db.collection("User").document(user!.email!).setData([
                            "UserName": userName,
                            "Address": address,
                            "Type": type,
                            "ImageURL":self.photoURL!], merge: true)
                        self.currentuser = User(userName: userName, imageURL: self.photoURL, address: address, type: type)
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
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
//        if let view = self.parent?.parent?.children[3].children[0] as? NewsViewController
//        {
//            view.tableView.reloadData()
//        }
      //   print(self.parent?.parent?.children[3].children[0].children)
    }
    
    @IBAction func changeProfileImage(_ sender: UIButton) {
        showImagePickerControllerActionSheet()
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
extension ReportViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func showImagePickerControllerActionSheet() {
        let photoLibaryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePickerController(.photoLibrary)
        }
        //        let cameraAction = UIAlertAction(title: "Take a new photo", style: .default) { (action) in
        //            self.showImagePickerController(.camera)
        //        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertService.showAlert(style: .actionSheet, title: "Choose your profile image", message: nil, actions: [photoLibaryAction,cancelAction], completion: nil)
    }
    
    func showImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profileImage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImage.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
extension ReportViewController : SingleUserManagerDelegate{
    func dataDidUpdate(_ sender: SingleUserManager, _ data: User) {
        currentuser = data
        if let name = currentuser?.userName{
            nameField.text = name
        }
        //get profile image
        if let url = currentuser?.imageURL{
            ImageService.downloadImage(withURL: URL(string: url)! ) { (image) in
                self.profileImage.image = image
            }
        }
        //get user's field
        if let address = currentuser?.address{
            self.addressField.text = address
        }
        if let type = currentuser?.type{
            self.typeField.text = type
        }
    }
}
