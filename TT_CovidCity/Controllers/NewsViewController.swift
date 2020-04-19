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
    var postToPass : Post?
    var docref : CollectionReference!
    var a : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        setupTable()
        self.tabBarItem.selectedImage = UIImage.init(systemName: "paperplane.fill")
    }
    func setupTable(){
        tableView.register(UINib(nibName: PostCell.PostCellID, bundle: nil), forCellReuseIdentifier: PostCell.PostCellID)
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
                            let newPost = Post(caption: caption, image: image, time: time, numberOfLike: numberOfLike, numberOfComment: numberOfComment, user: Writter(name: user["Name"], profileImage: user["Image"]),id: doc.documentID)
                            self.posts.append(newPost)
                            self.a = 9
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
        cell.delegate = self
        return cell
    }
    
    
}
extension NewsViewController: PostCellDelegate{
    func didTapped(_ data: Post) {
        postToPass = data
        self.performSegue(withIdentifier: "PostResult", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostResult"
        {
            let destinationMV = segue.destination as! FullPostController
            destinationMV.post = postToPass
        }
        if segue.identifier == "GotoLogin"
        {
            let destinationMV = segue.destination as! LoginViewController
            destinationMV.check = 1
            destinationMV.parentview = self
        }
    }
}
