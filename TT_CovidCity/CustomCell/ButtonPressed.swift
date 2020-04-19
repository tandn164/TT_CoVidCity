//
//  ButtonPressed.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/16/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase
struct ButtonPressed {
    let post : Post?
    let type : Int?
    let parent : UITableViewCell?
    var db = Firestore.firestore()
    init(_ post: Post, _ type: Int, _ parent: UITableViewCell) {
        self.post = post
        self.type = type
        self.parent = parent
    }
    func update(){
        if Auth.auth().currentUser != nil {
            if type == 0 {
                likeEvent()
            }else if type == 1 {
                commentEvent()
            }
        } else {
            let arlert = UIAlertController(title: "Login", message: "you need to log in", preferredStyle: .alert)
            let action = UIAlertAction(title: "Log in", style: .cancel) { (action) in
                DispatchQueue.main.async {
                    self.parent?.parentContainerViewController()?.performSegue(withIdentifier: "GotoLogin", sender: self.parent?.parentContainerViewController())
                }
            }
            arlert.addAction(action)
            parent?.parentContainerViewController()?.present(arlert, animated: true, completion: nil)
        }
    }
    func likeEvent(){
        let user = Auth.auth().currentUser
        let docRef = db.collection("Post/\(post!.id!)/Likes").document((user?.email)!)
        docRef.getDocument(source: .cache) { (document, error) in
            if let doc = document
            {
                if doc.exists
                    
                {
                    self.userLiked()
                    
                }
                else
                {
                    self.userHavenLikeYet()
                }
            }
            else
            {
                self.userHavenLikeYet()
            }
        }
    }
    func commentEvent(){
        
    }
    func userLiked(){
        let user = Auth.auth().currentUser
        if let cell = self.parent as? PostCell
        {
            self.db.collection("Post/\(self.post!.id!)/Likes").document((user?.email)!).delete { (err) in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    cell.likeButton.imageView?.tintColor = .darkGray
                    print("Document successfully removed!")
                }
            }
        } else if let cell = self.parent as? FullPostCell
        {
            self.db.collection("Post/\(self.post!.id!)/Likes").document((user!.email)!).delete { (err) in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    cell.likeButton.imageView?.tintColor = .darkGray
                }
            }
            if let view = self.parent?.parentContainerViewController()?.parent?.children[0] as? NewsViewController
            {
                view.tableView.reloadData()
            }
            print("Document successfully removed!")
        }
    }
    func userHavenLikeYet() {
        let user = Auth.auth().currentUser
        if let cell = self.parent as? PostCell
        {
            self.db.collection("Post/\(self.post!.id!)/Likes").document((user?.email)!).setData([:]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    cell.likeButton.imageView?.tintColor = .cyan
                    print("Document successfully written!")
                }
            }
        } else if let cell = self.parent as? FullPostCell
        {
            self.db.collection("Post/\(self.post!.id!)/Likes").document((user?.email)!).setData([:]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    cell.likeButton.imageView?.tintColor = .cyan
                    print("Document successfully written!")
                }
            }
            if let view = self.parent?.parentContainerViewController()?.parent?.children[0] as? NewsViewController
            {
                view.tableView.reloadData()
            }
        }
    }
}
