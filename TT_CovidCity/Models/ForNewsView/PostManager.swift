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
class PostManager{
    var db = Firestore.firestore()
    var delegate : PostManagerDelegate?
    func loadData(){
        db.collection("Post").addSnapshotListener { (querySnapshot, error) in
            var posts : [Post] = []

            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments {
                    let data = doc.data()
                        let numberOfLike = String("\(self.countLike(doc.documentID))")
                        print(numberOfLike)
                        if let caption = data["Caption"] as? String, let image = data["Image"] as? String, let numberOfComment = data["NumberOfComment"] as? String, let user = data["User"] as? [String: String], let time = data["Time"] as? Double, let numberOfLike = data["NumberOfLike"] as? String
                        {
                            let date = Date(timeIntervalSince1970: time)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.timeZone = .current
                            let localDate = dateFormatter.string(from: date)
                            let newPost = Post(caption: caption, image: image, time: localDate, numberOfLike: numberOfLike, numberOfComment: numberOfComment, user: Writter(name: user["Name"], profileImage: user["Image"]),id: doc.documentID)
                            posts.append(newPost)
                        }
                        
                    }
                    DispatchQueue.main.async {
                       // self.tableView.reloadData()
                        self.delegate?.dataDidUpdate(self, posts)
                    }
                }
            }
        }
    }
//    func countLike(_ id : String) -> Int {
//        var numberOfLikes : Int?
//        print(54)
//        db.collection("Post/\(id)/Likes").getDocuments { (query, err) in
//            print("Post/\(id)/Likes")
//            numberOfLikes = query?.count
//            print(numberOfLikes)
//        }
//        if numberOfLikes == nil
//        {
//            return 0
//        } else {
//            return numberOfLikes!
//        }
//    }
}
