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
import SwipeCellKit
//import FirebaseStorage

class ReportViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
  @IBOutlet weak var editButton: UIButton!
  
    var image : UIImage?
    var child = ChoosePlaceController()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var lat: Double!
    var long: Double!
    var userManager : SingleUserManager?
    var locations : VisitedLocationManager?
    var currentuser : User?
    let db = Firestore.firestore()
    var photoURL : String?
    var visitedLocation : [VisitedLocation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewData()
        navigationItem.hidesBackButton = true
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        child.delegate = self
    
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setView()
      //tableView.backgroundColor = UIColor.clear
      tableView.layer.cornerRadius = 7
      tableView.layer.shadowColor = UIColor.darkGray.cgColor
      tableView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0 )
      tableView.layer.shadowOpacity = 1.0
      tableView.layer.shadowRadius = 2
      
      let backgroundImage = UIImageView(frame: view.frame)
      backgroundImage.image = UIImage(named: "reportBackground")
      self.view.insertSubview(backgroundImage, at: 0)
      profileImage.layer.cornerRadius = 7
    }
    func setView() {
        addressField.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        typeField.attributedPlaceholder = NSAttributedString(string: "Type", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tableView.backgroundColor = .white
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
        //push profile image
        image = profileImage.image
        guard let imageSelected = image else {
            print("Image is null")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let storageRef = Storage.storage().reference(forURL: storage.storageRefURL)
        let storageProfileRef = storageRef.child(storage.profile).child((user?.email)!)
        let metaData = StorageMetadata()
        metaData.contentType = storage.contentType
        storageProfileRef.putData(imageData, metadata: metaData) { (storage, err) in
            if let err = err {
                print(err)
                return
            }else{
                
                storageProfileRef.downloadURL { (url, err) in
                    self.photoURL = url?.absoluteString
                    if let type = self.typeField.text, let userName = self.nameField.text, let address = self.addressField.text{
                        self.db.collection(Database.user).document(user!.email!).setData([
                            Database.User.UserName: userName,
                            Database.User.Address: address,
                            Database.User.Type1: type,
                            Database.User.ImageURL:self.photoURL!,
                            Database.User.Lon: self.locationManager.location?.coordinate.longitude ?? 0.0 ,
                            Database.User.Lat: self.locationManager.location?.coordinate.latitude ?? 0.0], merge: true)
                        self.currentuser = User(userName: userName, imageURL: self.photoURL, address: address, type: type)
                        self.db.collection(Database.location).document(user!.email!).setData([
                            Database.Location.locationName: "",
                            Database.Location.lat:self.locationManager.location?.coordinate.latitude ?? 0.0 ,
                            Database.Location.lon:self.locationManager.location?.coordinate.longitude ?? 0.0 ,
                            Database.Location.userType: type], merge: true)
                        //Add visited table
                        for i in self.visitedLocation{
                            self.db.collection(Path.pathToVistedLocation(withID: user!.email!)).document(i.locationAddress!).setData([
                                Database.User.VisitedLocation.locationName:i.locationAddress!,
                                Database.User.VisitedLocation.lat:i.lat!,
                                Database.User.VisitedLocation.lon:i.lon!], merge: true)
                            self.db.collection(Database.location).document(i.locationAddress!).setData([
                                Database.Location.locationName: i.locationAddress!,
                                Database.Location.lat: i.lat!,
                                Database.Location.lon: i.lon!,
                                Database.Location.userType: String("\(type) visited")
                            ], merge: true)
                        }
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
    
    
    @IBAction func addLocationTap(_ sender: UIButton) {
        child.visitedLocation = self.visitedLocation
        self.show(child, sender: self)
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
        let cameraAction = UIAlertAction(title: "Take a new photo", style: .default) { (action) in
            self.showImagePickerController(.camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertService.showAlert(style: .actionSheet, title: "Choose your profile image", message: nil, actions: [photoLibaryAction,cameraAction,cancelAction], completion: nil)
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
        getVistedPlace()
    }
    func getVistedPlace() {
        locations = VisitedLocationManager((Auth.auth().currentUser?.email)!)
        locations?.delegate = self
        locations?.loadData()
    }
}
extension ReportViewController: ChoosePlaceControllerDelegate{
    func didGetvisitedLocation(from sender: ChoosePlaceController, _ data: [VisitedLocation]) {
        visitedLocation = data
        tableView.reloadData()
    }
}
extension ReportViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
extension ReportViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitedLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "visitedLocationCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = visitedLocation[indexPath.row].locationAddress
        cell.delegate = self
        return cell
    }
}
extension ReportViewController: VisitedLocationManagerDelegate{
    func dataDidUpdate(_ sender: VisitedLocationManager, _ data: [VisitedLocation]) {
        visitedLocation = data
        tableView.reloadData()
    }
}
extension ReportViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let user = Auth.auth().currentUser
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            DispatchQueue.main.async{
                self.db.collection(Path.pathToVistedLocation(withID: user!.email!)).document(self.visitedLocation[indexPath.row].locationAddress!).delete()
                self.visitedLocation.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }

        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
