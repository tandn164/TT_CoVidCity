//
//  FourViewController.swift
//  abc
//
//  Created by Trần Nhất Thống on 3/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase

class NewsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var posts : [Post] = []
    var docref : CollectionReference!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        self.tabBarItem.selectedImage = UIImage.init(systemName: "paperplane.fill")
    }
    func loadPost() {
        db.collection("Post").addSnapshotListener { (querySnapshot, error) in
            self.posts = []
        
            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let caption = data["Caption"] as? String, let image = data["Image"] as? String, let numberOfLike = data["NumberOfLike"] as? String, let numberOfComment = data["NumberOfComment"] as? String, let time = data["TimeAgo"] as? String, let user = data["User"] as? [String: String]
                        {
                            print(user)
                            let newPost = Post(caption: caption, image: image, time: time, numberOfLike: numberOfLike, numberOfComment: numberOfComment, user: Writter(name: user["Name"], profileImage: user["Image"]))
                            self.posts.append(newPost)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            
                        }
                        
                    }
                }
            }
        }
    }
   
}
extension NewsViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
extension NewsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.PostCellID, for: indexPath) as! PostCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    
}

