//
//  PostResultController.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/10/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase
class FullPostController: UIViewController {
    var post : Post?
    var comment : [Comment] = []
    var db = Firestore.firestore()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableCell()
        loadComment()
    }
    func loadComment(){
        db.collection("Post/\(post!.id!)/comment").addSnapshotListener { (querySnapshot, error) in
            self.comment = []
            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let userName = data["UserName"] as? String, let image = data["UserProfileImage"] as? String, let cmt = data["Comment"] as? String, let time = data["Time"] as? String
                        {
                            let newComment = Comment(comment: cmt, time: time, userName: userName, userProfileImage: image)
                            self.comment.append(newComment)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
    func setTableCell(){
        tableView.register(UINib(nibName: FullPostCell.FullPostCellID, bundle: nil), forCellReuseIdentifier: FullPostCell.FullPostCellID)
        tableView.register(UINib(nibName: CommentCell.CommentCellID, bundle: nil), forCellReuseIdentifier: CommentCell.CommentCellID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoLogin"
        {
            let destinationMV = segue.destination as! LoginViewController
            destinationMV.check = 1
            destinationMV.parentview = self
        }
    }
    @IBAction func sendPressed(_ sender: Any) {
        self.textField.endEditing(true)
    }
}
extension FullPostController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else
        {
            return comment.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FullPostCell.FullPostCellID, for: indexPath) as! FullPostCell
            cell.post = post
            return cell}
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.CommentCellID, for: indexPath) as! CommentCell
            cell.comment = comment[indexPath.row]
            return cell
        }
        //   return UITableViewCell()
    }
}
extension FullPostController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}
extension FullPostController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }
        else{
            let arlert = UIAlertController(title: "Login", message: "you need to log in", preferredStyle: .alert)
            let action = UIAlertAction(title: "Log in", style: .cancel) { (action) in
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "GotoLogin", sender: self)
                }
            }
            arlert.addAction(action)
            self.present(arlert, animated: true, completion: nil)
            return false
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        }
        else{
            self.textField.placeholder = "Type something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let user = Auth.auth().currentUser
        // let userName = user?.displayName
         let sender = "tan"
         if let comment = textField.text{
             db.collection("Post/\(post!.id!)/comment").addDocument(data: ["UserName":sender, "Comment":comment,"Time": "15m", "UserProfileImage":"tan"]){(error) in
                     if let err = error {
                         print(err)
                     } else {
                         print("OK")
                         DispatchQueue.main.async {
                             self.textField.text = ""
                             self.textField.endEditing(true)
                             self.tableView.reloadData()
                             let indexPath = IndexPath(row: self.comment.count-1, section: 1)
                             self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                         }
                        
                     }
                 }
         }
        self.textField.text = ""
    }
}
