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
    var postId : String?
    var commentManager : CommentManager?
    var fullPost : SinglePostManager?
    var userManager : SingleUserManager?
    var currentUser : User?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let id = postId else {
            print("No post exits")
            return
        }
        print(id)
        commentManager = CommentManager(id)
        commentManager?.delegate = self
        fullPost = SinglePostManager(id)
        fullPost?.delegate = self
        if Auth.auth().currentUser != nil{
            userManager = SingleUserManager((Auth.auth().currentUser?.email)!)
            userManager?.delegate = self
        }
        
        loadData()
        setTableCell()

    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func loadData(){
        fullPost?.loadData()
        userManager?.loadData()
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
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.CommentCellID, for: indexPath) as! CommentCell
            cell.comment = comment[indexPath.row]
            return cell
        }
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
            let arlert = UIAlertController(title: "You haven't logined yet", message: "You need to log in", preferredStyle: .alert)
            let action = UIAlertAction(title: "Login", style: .cancel) { (action) in
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.endEditing(true)
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let comment = textField.text{
            db.collection("Post/\(post!.id!)/comment").addDocument(data: ["UserName":currentUser?.userName!, "Comment":comment,"Time": Date().timeIntervalSince1970, "UserProfileImage": currentUser?.imageURL]){(error) in
                     if let err = error {
                         print(err)
                     } else {
                         let numberOfComments = String("\(Int(self.post!.numberOfComment!)!+1)")
                         let updateComment = self.db.collection("Post").document("\(self.post!.id!)")
                         updateComment.updateData(["NumberOfComment":numberOfComments]) { err in
                         if let err = err {
                             print("Error updating document: \(err)")
                         } else {
                             print("Document successfully updated")
                         }
                         }
                         DispatchQueue.main.async {
                             self.textField.text = ""
                             self.textField.endEditing(true)
                             self.tableView.reloadData()
                             if self.comment.count > 1{
                                let indexPath = IndexPath(row: self.comment.count-1, section: 1)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                         }
                        
                     }
                 }
         }
        self.textField.text = ""
    }
}
extension FullPostController : CommentManagerDelegate{
    func dataDidUpdate(_ commentManager: CommentManager, _ data: [Comment]) {
        comment = data
        self.tableView.reloadData()
        
    }
    
}
extension FullPostController : SinglePostManagerDelegate{
    func dataDidUpdate(_ sender: SinglePostManager, _ data: Post) {
        post = data
        //self.tableView.reloadData()
        commentManager?.loadData()
    }
}
extension FullPostController : SingleUserManagerDelegate{
    func dataDidUpdate(_ sender: SingleUserManager, _ data: User) {
        currentUser = data
    }
}
