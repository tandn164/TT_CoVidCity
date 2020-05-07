//
//  AdminViewController.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/21/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase
class AdminViewController: UIViewController {
  @IBOutlet weak var nameField: UILabel!
  @IBOutlet weak var postTextField: UITextField!
  @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postImage: UIImageView!
  @IBOutlet weak var profileImage: UIImageView!
  
    let user = Auth.auth().currentUser!
    var db = Firestore.firestore()
    var userManager : SingleUserManager?
    var currentUser : User?
    var image : UIImage?
    var photoURL : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postImage.image = UIImage(systemName: "photo.fill")
        userManager = SingleUserManager((Auth.auth().currentUser?.email)!)
        userManager?.delegate = self
        userManager?.loadData()
        postTextView.delegate = self
        navigationItem.hidesBackButton = true
    }
    override func viewWillAppear(_ animated: Bool) {
        setView()
      profileImage.layer.cornerRadius = profileImage.frame.height/2
      postTextView.layer.cornerRadius = 7
      postTextView.layer.backgroundColor = #colorLiteral(red: 1, green: 0.9176470588, blue: 0.6957510744, alpha: 1)
    }
    func setView() {
        postTextView.backgroundColor = .white
    }
    @IBAction func postPressed(_ sender: UIButton) {
        //self.postTextView.endEditing(true)
        
        if postTextView.text != ""
        {
            uploadPost()
        }
        else{
            let alert = UIAlertController(title: "Input somthing pls", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
    @IBAction func selectImage(_ sender: UIButton) {
        showImagePickerControllerActionSheet()
    }
    func uploadPost()  {
        image = postImage.image
        guard let imageSelected = image else {
            print("Image is null")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
            return
        }
        let date = String("\(Date().timeIntervalSince1970)")
        let storageRef = Storage.storage().reference(forURL: storage.storageRefURL)
        let storageProfileRef = storageRef.child(storage.post).child(date)
        let metaData = StorageMetadata()
        metaData.contentType = storage.contentType
        storageProfileRef.putData(imageData, metadata: metaData) { (storage, err) in
            if let err = err {
                print(err)
                return
            }else{
                storageProfileRef.downloadURL { (url, err) in
                    self.photoURL = url?.absoluteString
                    if let post = self.postTextView.text{
                      self.db.collection(Database.post).addDocument(data: [Database.Post.Image: self.photoURL as Any,Database.Post.Caption:post,Database.Post.NumberOfComment:"0",Database.Post.NumberOfLike:"0",Database.Post.Time:Date().timeIntervalSince1970,Database.Post.User:[Database.Post.UserImage:self.currentUser?.imageURL,Database.Post.UserName:self.currentUser?.userName]]) { (error) in
                            if let err = error{
                                print(err)
                            }else
                            {
                                let alert = UIAlertController(title: "New post uploaded", message: "", preferredStyle: .alert)
                                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                    self.postTextView.text = ""
                }
                
            }
        }
    }
}
extension AdminViewController: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
extension AdminViewController : SingleUserManagerDelegate{
    func dataDidUpdate(_ sender: SingleUserManager, _ data: User) {
        print(data)
        currentUser = data
        //nameField.text = currentUser?.userName
        
    }
}
extension AdminViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
            postImage.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            postImage.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}
