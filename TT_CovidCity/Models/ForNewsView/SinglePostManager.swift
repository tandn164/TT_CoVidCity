//
//  SinglePostManager.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
import Firebase
protocol SinglePostManagerDelegate {
    func dataDidUpdate(_ sender: SinglePostManager, _ data: Post)
}
class SinglePostManager {
    var db = Firestore.firestore()
    var delegate : SinglePostManagerDelegate?
    var id : String?
    init(_ id : String) {
        self.id = id
    }
    func loadData() {
        db.collection(Database.post).document(id!).addSnapshotListener { (documents, err) in
            let data = documents!.data()!
            if let caption = data[Database.Post.Caption] as? String, let image = data[Database.Post.Image] as? String, let numberOfLike = data[Database.Post.NumberOfLike] as? String, let numberOfComment = data[Database.Post.NumberOfComment] as? String, let user = data[Database.Post.User] as? [String: String], let time = data[Database.Post.Time] as? Double
            {
                let date = Date(timeIntervalSince1970: time)
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                dateFormatter.timeZone = .current
                let localDate = dateFormatter.string(from: date)
                let post = Post(caption: caption, image: image, time: localDate, numberOfLike: numberOfLike, numberOfComment: numberOfComment, user: Writter(name: user[Database.Post.UserName], profileImage: user[Database.Post.UserImage]),id: self.id)
                self.delegate?.dataDidUpdate(self, post)
            } else {
                print("Document does not exist")
            }
        }
    }
}
