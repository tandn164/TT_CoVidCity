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
    override func viewDidLoad() {
        super.viewDidLoad()
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
                    let changeRequest = authResult?.user.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges(completion: { (err) in
                        if let err = err {
                            print(err)
                        }
                    })
                    self.performSegue(withIdentifier: "RegistertoReport", sender: self)
                }
            }
        }
        
    }
    
    
}
