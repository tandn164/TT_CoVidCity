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
        db.collection("Post").document(id!).addSnapshotListener { (documents, err) in
            let data = documents!.data()!
            if let caption = data["Caption"] as? String, let image = data["Image"] as? String, let numberOfLike = data["NumberOfLike"] as? String, let numberOfComment = data["NumberOfComment"] as? String, let user = data["User"] as? [String: String], let time = data["Time"] as? Double
            {
                let date = Date(timeIntervalSince1970: time)
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                dateFormatter.timeZone = .current
                let localDate = dateFormatter.string(from: date)
                let post = Post(caption: caption, image: image, time: localDate, numberOfLike: numberOfLike, numberOfComment: numberOfComment, user: Writter(name: user["Name"], profileImage: user["Image"]),id: self.id)
                self.delegate?.dataDidUpdate(self, post)
            } else {
                print("Document does not exist")
            }
        }
        
        //        let docRef = db.collection("Post").document(id!)
        //        docRef.getDocument { (document, error) in
        //            if let document = document, document.exists {
        //                let data = document.data()!
        //                if let caption = data["Caption"] as? String, let image = data["Image"] as? String, let numberOfLike = data["NumberOfLike"] as? String, let numberOfComment = data["NumberOfComment"] as? String, let user = data["User"] as? [String: String], let time = data["Time"] as? Double
        //                {
        //                    let date = Date(timeIntervalSince1970: time)
        //                    let dateFormatter = DateFormatter()
        //                    dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        //                    dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        //                    dateFormatter.timeZone = .current
        //                    let localDate = dateFormatter.string(from: date)
        //                    let post = Post(caption: caption, image: image, time: localDate, numberOfLike: numberOfLike, numberOfComment: numberOfComment, user: Writter(name: user["Name"], profileImage: user["Image"]),id: self.id)
        //                    self.delegate?.dataDidUpdate(self, post)
        //                }
        //            } else {
        //                print("Document does not exist")
        //            }
        //        }
    }
}
