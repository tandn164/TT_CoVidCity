//
//  RegisterViewController.swift
//  TT_CovidCity
//
//  Created by Trần Nhất Thống on 3/28/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {
  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  @IBOutlet weak var usernameTextField: UITextField!
  var db = Firestore.firestore()
  override func viewDidLoad() {
    super.viewDidLoad()
    setView()
  }
  @IBOutlet weak var nextButton: UIButton!
  
  override func viewWillAppear(_ animated: Bool) {
    nextButton.layer.cornerRadius = 7
    let backgroundImage = UIImageView(frame: view.frame)
    backgroundImage.image = UIImage(named: "registerBackground")
    self.view.insertSubview(backgroundImage, at: 0)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.tintColor = .red
  }
  
  func setView() {
    usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    emailTextfield.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
  }
  @IBAction func registerButtonPressed (_ sender: UIButton) {
    if let email = emailTextfield.text, let password = passwordTextfield.text, let username = usernameTextField.text
    {
      Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
        if let err = error {
          let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
          let action = UIAlertAction(title: "Done", style: .default) { (action) in
          }
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
        } else {
          //create new user with userName, id is uid
          self.db.collection(Database.user).document(email).setData([Database.User.UserName:username,Database.User.Type1: "",Database.User.Address: "", Database.User.ImageURL:storage.defaultImageURL]) { (error) in
            if let err = error {
              print("Error writing document: \(err)")
            } else {
              
              print("Document successfully written!")
            }
          }
          Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
              let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
              let action = UIAlertAction(title: "Done", style: .default) { (action) in
              }
              alert.addAction(action)
              self.present(alert, animated: true, completion: nil)
            } else {
              self.performSegue(withIdentifier: SegueIdentify.RegistertoReport, sender: self)
            }
          }
          
        }
      }
    }
    
  }
  
  
}
