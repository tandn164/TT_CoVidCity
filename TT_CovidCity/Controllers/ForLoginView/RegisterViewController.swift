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
                    self.db.collection("User").document(email).setData(["UserName":username,"Type": "","Address": "", "ImageURL":"https://firebasestorage.googleapis.com/v0/b/covidcity-1585012064634.appspot.com/o/profile%2Fadmin%40gmail.com.jpeg?alt=media&token=9a4b1374-d0dc-413a-aa41-0cb75bd29167"]) { (error) in
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
                            self.performSegue(withIdentifier: "RegistertoReport", sender: self)
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
}
