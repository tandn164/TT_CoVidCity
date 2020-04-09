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
  @IBOutlet weak var usernameTextfield: UITextField!
  @IBOutlet weak var passwordTextfield: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func registerButtonPressed (_ sender: UIButton) {
    if let username = usernameTextfield.text, let password = passwordTextfield.text
    {
      Auth.auth().createUser(withEmail: username, password: password){ authResult, error in
        if let err = error {
          let alert = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
          let action = UIAlertAction(title: "Done", style: .default) { (action) in
          }
          alert.addAction(action)
          self.present(alert, animated: true, completion: nil)
        } else {
          self.performSegue(withIdentifier: "RegistertoReport", sender: self)
        }
      }
    }  }
  
  
}
