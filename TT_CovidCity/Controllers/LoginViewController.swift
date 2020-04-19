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
        print(check)
    }
    //Neu nguoi dung da dang nhap thi chuyen den report luon
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "LogintoReport", sender: self)
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
                    // Neu login duoc goi tu new thi se return new khi bam login
                    if self.check == 1 {
                        self.comeFromNews()
                    } else {
                        //Neu khong thi chuyen den report
                        self.performSegue(withIdentifier: "LogintoReport", sender: self)
                    }
                    
                }
                // ...
            }
        }
    }
    func comeFromNews() {
        if let view = self.parentview as? NewsViewController
        {
            view.tableView.reloadData()
        }
        else if let view = self.parentview as? FullPostController
        {
            view.tableView.reloadData()
            if let viewParentView = view.parent?.children[0] as? NewsViewController
            {
                viewParentView.tableView.reloadData()
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
