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
    let postManager = PostManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPost()
        setupTable()
        navigationItem.hidesBackButton = true
        self.tabBarItem.selectedImage = UIImage.init(systemName: "paperplane.fill")
    }
    func setupTable(){
        tableView.register(UINib(nibName: PostCell.PostCellID, bundle: nil), forCellReuseIdentifier: PostCell.PostCellID)
    }
    func loadPost() {
        postManager.delegate = self
        postManager.loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
            destinationMV.postId = postToPass?.id
           // destinationMV.post = postToPass
            print(87)
        }
        if segue.identifier == "GotoLogin"
        {
            let destinationMV = segue.destination as! LoginViewController
            destinationMV.check = 1
            destinationMV.parentview = self
        }
    }
}
extension NewsViewController : PostManagerDelegate{
    func dataDidUpdate(_ PostManager: PostManager, _ data: [Post]) {
        posts = data
        tableView.reloadData()
    }
}
