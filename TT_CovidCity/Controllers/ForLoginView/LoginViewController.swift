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
    var check = 0;
    weak var parentview : UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    func setView() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    override func viewDidAppear(_ animated: Bool) {
        if let currentUser = Auth.auth().currentUser{
            if currentUser.email! == Authentication.admin
            {
                self.performSegue(withIdentifier: SegueIdentify.LogintoAdmin, sender: self)
            }else
            {
                self.performSegue(withIdentifier: SegueIdentify.LogintoReport, sender: self)
            }
        }
        
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
                    if self.check == 1 {
                       self.comeFromNews()
                    } else {
                        if username == Authentication.admin
                        {
                            self.performSegue(withIdentifier: SegueIdentify.LogintoAdmin, sender: self)
                        } else {
                            self.performSegue(withIdentifier: SegueIdentify.LogintoReport, sender: self)
                        }
                    }
                    
                }
                // ...
            }
        }
    }
    func comeFromNews() {
        if let view = self.parentview as? NewsViewController
        {
            view.viewWillAppear(true)
           // view.tableView.reloadData()
        }
        else if let view = self.parentview as? FullPostController
        {
           // view.tableView.reloadData()
            view.viewWillAppear(true)
            if let viewParentView = view.parent?.children[0] as? NewsViewController
            {
                
               viewParentView.viewWillAppear(true)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
