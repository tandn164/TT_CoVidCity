//
//  CommentManager.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
import Firebase
protocol CommentManagerDelegate {
    func dataDidUpdate(_ commentManager: CommentManager, _ data : [Comment])
}
class CommentManager{
    var db = Firestore.firestore()
    var delegate : CommentManagerDelegate?
    var id : String?
    init(_ id: String) {
        self.id = id
    }
    func loadData() {
        db.collection("Post/\(id!)/comment").addSnapshotListener { (querySnapshot, error) in
            var comment : [Comment] = []
            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let userName = data["UserName"] as? String, let image = data["UserProfileImage"] as? String, let cmt = data["Comment"] as? String, let time = data["Time"] as? Double
                        {
                            let date = Date(timeIntervalSince1970: time)
                            let dateFormatter = DateFormatter()
                            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
                            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
                            dateFormatter.timeZone = .current
                            let localDate = dateFormatter.string(from: date)
                            let newComment = Comment(comment: cmt, time: localDate, userName: userName, userProfileImage: image)
                            comment.append(newComment)
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.delegate?.dataDidUpdate(self, comment)
                    }
                }
            }
        }
    }
}
