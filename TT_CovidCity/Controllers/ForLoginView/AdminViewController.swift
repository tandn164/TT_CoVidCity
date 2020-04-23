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
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var postTextView: UITextView!
    let user = Auth.auth().currentUser!
    var db = Firestore.firestore()
    var userManager : SingleUserManager?
    var currentUser : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        userManager = SingleUserManager((Auth.auth().currentUser?.email)!)
        userManager?.delegate = self
        userManager?.loadData()
        postTextView.delegate = self
        navigationItem.hidesBackButton = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    @IBAction func postPressed(_ sender: UIButton) {
        self.postTextView.endEditing(true)
    }
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
extension AdminViewController: UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        if let post = postTextView.text{
            db.collection(Database.post).addDocument(data: [Database.Post.Image: "3",Database.Post.Caption:post,Database.Post.NumberOfComment:"0",Database.Post.NumberOfLike:"0",Database.Post.Time:Date().timeIntervalSince1970,Database.Post.User:[Database.Post.UserImage:currentUser?.imageURL,Database.Post.UserName:currentUser?.userName]]) { (error) in
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
        textView.text = ""
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text != ""
        {
            return true
        }
        else{
            let alert = UIAlertController(title: "Input somthing pls", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return false
        }
    }
}
extension AdminViewController : SingleUserManagerDelegate{
    func dataDidUpdate(_ sender: SingleUserManager, _ data: User) {
        print(data)
        currentUser = data
        nameField.text = currentUser?.userName

    }
    
    
}
