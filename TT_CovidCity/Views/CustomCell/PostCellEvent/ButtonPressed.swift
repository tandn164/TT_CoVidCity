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
            let arlert = UIAlertController(title: "You haven't logined yet", message: "You need to login", preferredStyle: .alert)
            let action = UIAlertAction(title: "Login", style: .cancel) { (action) in
                DispatchQueue.main.async {
                    self.parent?.parentContainerViewController()?.performSegue(withIdentifier: SegueIdentify.gotoLogin, sender: self.parent?.parentContainerViewController())
                }
            }
            arlert.addAction(action)
            parent?.parentContainerViewController()?.present(arlert, animated: true, completion: nil)
        }
    }
    func likeEvent(){
        let user = Auth.auth().currentUser
        let docRef = db.collection(Path.pathToLikes(withID: post!.id!)).document((user?.email)!)
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
        if let view = self.parent as? PostCell{
            view.delegate?.didTapped(view.post)
        }
        else if let view = self.parent?.parentContainerViewController() as? FullPostController{
            view.textFieldDidBeginEditing(view.textField)
        }
    }
    
    func userLiked(){
        let user = Auth.auth().currentUser

        if let cell = self.parent as? PostCell
        {
            self.db.collection(Path.pathToLikes(withID: self.post!.id!)).document((user?.email)!).delete { (err) in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    cell.likeButton.imageView?.tintColor = .darkGray
                    let numberOfLikes = String("\(Int(self.post!.numberOfLike!)!-1)")
                    let updateLike = self.db.collection(Database.post).document("\(self.post!.id!)")
                    updateLike.updateData([Database.Post.NumberOfLike:numberOfLikes]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                    }
                    print("Document successfully removed!")
                }
            }
        } else if let cell = self.parent as? FullPostCell
        {
            self.db.collection(Path.pathToLikes(withID: self.post!.id!)).document((user!.email)!).delete { (err) in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    cell.likeButton.imageView?.tintColor = .darkGray
                    let numberOfLikes = String("\(Int(self.post!.numberOfLike!)!-1)")
                    let updateLike = self.db.collection(Database.post).document("\(self.post!.id!)")
                    updateLike.updateData([Database.Post.NumberOfLike:numberOfLikes]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                    }
                    cell.postStatsLabel.text = "\(numberOfLikes) likes"
                    print("Document successfully removed!")
                }
            }
            
        }
    }
    
    func userHavenLikeYet() {
        let user = Auth.auth().currentUser

        if let cell = self.parent as? PostCell
        {
            self.db.collection(Path.pathToLikes(withID: self.post!.id!)).document((user?.email)!).setData([:]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    cell.likeButton.imageView?.tintColor = .cyan
                    let numberOfLikes = String("\(Int(self.post!.numberOfLike!)!+1)")
                    let updateLike = self.db.collection(Database.post).document("\(self.post!.id!)")
                    updateLike.updateData([Database.Post.NumberOfLike:numberOfLikes]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                    }
                    print("Document successfully written!")
                }
            }
        } else if let cell = self.parent as? FullPostCell
        {
            self.db.collection(Path.pathToLikes(withID: self.post!.id!)).document((user?.email)!).setData([:]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    cell.likeButton.imageView?.tintColor = .cyan
                    let numberOfLikes = String("\(Int(self.post!.numberOfLike!)!+1)")
                    let updateLike = self.db.collection(Database.post).document("\(self.post!.id!)")
                    updateLike.updateData([Database.Post.NumberOfLike:numberOfLikes]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                    }
                    cell.postStatsLabel.text = "\(numberOfLikes) likes"
                    print("Document successfully written!")
                }
            }
            
        }
    }
}
