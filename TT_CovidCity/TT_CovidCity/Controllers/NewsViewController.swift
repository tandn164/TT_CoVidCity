//
//  FourViewController.swift
//  abc
//
//  Created by Trần Nhất Thống on 3/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    var posts: [Posts]?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
    super.viewDidLoad()
    fetchPosts()
  }
    func fetchPosts() {
        posts = Posts.fetchPosts()
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
        if let posts = posts{
            return posts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.PostCellID, for: indexPath) as! PostCell
        cell.post = posts![indexPath.row]
        return cell
    }
    
    
}
