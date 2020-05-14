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
    
    nextButton.backgroundColor = #colorLiteral(red: 0.1040239726, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
    nextButton.layer.shadowColor = UIColor.clear.cgColor
    
    let backgroundImage = UIImageView(frame: view.frame)
    backgroundImage.contentMode = .scaleAspectFill
    backgroundImage.clipsToBounds = true
    backgroundImage.image = UIImage(named: "registerBackground")
    self.view.insertSubview(backgroundImage, at: 0)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1058823529, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
    
    let yourBackImage = UIImage(named: "backButton")
    let scaledBackImage = yourBackImage?.scaledDown(into: CGSize(width: 25, height: 25), centered: true)
    self.navigationController?.navigationBar.backIndicatorImage = scaledBackImage
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = scaledBackImage
    
  }
  
  func setView() {
    usernameTextField.attributedPlaceholder = NSAttributedString(string: "Tên Người Dùng", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    passwordTextfield.attributedPlaceholder = NSAttributedString(string: "Mật Khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    emailTextfield.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
