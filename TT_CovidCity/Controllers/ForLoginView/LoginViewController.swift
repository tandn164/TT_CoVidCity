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
  
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  var check = 0;
    weak var parentview : UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
  override func viewWillAppear(_ animated: Bool) {
    
    loginButton.backgroundColor = #colorLiteral(red: 0.1040239726, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
    loginButton.layer.shadowColor = UIColor.clear.cgColor
    
    
    let backgroundImage = UIImageView(frame: view.frame)
    backgroundImage.contentMode = .scaleAspectFill
    backgroundImage.clipsToBounds = true
    backgroundImage.image = UIImage(named: "loginBackground")
    self.view.insertSubview(backgroundImage, at: 0)
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.tintColor = .red
    
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
  
    func setView() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Mật Khẩu", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
