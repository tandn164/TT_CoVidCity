//
//  PostResultController.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/10/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase
class FullPostController: UITableViewController {
    var post : Post?
    var comment : [Comment] = []
    var db = Firestore.firestore()
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
                    print(snapShotDocuments.count)
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let userName = data["UserName"] as? String, let image = data["UserProfileImage"] as? String, let cmt = data["Comment"] as? String, let time = data["Time"] as? String
                        {
                            let newComment = Comment(comment: cmt, time: time, userName: userName, userProfileImage: image)
                            self.comment.append(newComment)
                            print(newComment)
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else
        {
            return comment.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
