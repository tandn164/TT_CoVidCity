//
//  PostManager.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
import Firebase
protocol PostManagerDelegate {
    func dataDidUpdate(_ PostManager: PostManager, _ data: [Post])
}
struct PostManager{
    var db = Firestore.firestore()
    var delegate : PostManagerDelegate?
    func loadData(){
        db.collection(Database.post).addSnapshotListener { (querySnapshot, error) in
            var posts : [Post] = []

            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments {
                    let data = doc.data()
                        if let caption = data[Database.Post.Caption] as? String, let image = data[Database.Post.Image] as? String, let numberOfComment = data[Database.Post.NumberOfComment] as? String, let user = data[Database.Post.User] as? [String: String], let time = data[Database.Post.Time] as? Double, let numberOfLike = data[Database.Post.NumberOfLike] as? String
                        {
                            let date = Date(timeIntervalSince1970: time)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.timeZone = .current
                            let localDate = dateFormatter.string(from: date)
                            let newPost = Post(caption: caption, image: image, time: localDate, numberOfLike: numberOfLike, numberOfComment: numberOfComment, user: Writter(name: user[Database.Post.UserName], profileImage: user[Database.Post.UserImage]),id: doc.documentID)
                            posts.append(newPost)
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.delegate?.dataDidUpdate(self, posts)
                    }
                }
            }
        }
    }

}
