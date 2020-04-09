//
//  ThirdViewController.swift
//  abc
//
//  Created by Trần Nhất Thống on 3/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  @IBAction func loginPressed(_ sender: UIButton) {
    
    if let username = usernameTextField.text, let password = passwordTextField.text{
      Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
        if let err = error {
          let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
          let action = UIAlertAction(title: "Done", style: .default) { (action) in
          }
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
        } else {
          self.performSegue(withIdentifier: "LogintoReport", sender: self)
        }
        // ...
      }
    }
  }
  
  
}
