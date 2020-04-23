//
//  UserManager.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
import Firebase
protocol UserManagerDelegate {
    func dataDidUpdate(_ sender: UserManager, _ data : [User] )
}
class UserManager {
    var delegate : UserManagerDelegate?
    var db = Firestore.firestore()
    func loadData() {
        db.collection("User").addSnapshotListener { (querySnapshot, error) in
            var users : [User] = []

            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments {
                    let data = doc.data()
                        if let userName = data["UserName"] as? String, let imageURL = data["ImageURL"] as? String, let type = data["Type"] as? String, let address = data["Address"] as? String
                        {
                            let newUser = User(userName: userName, imageURL: imageURL, address: address,type: type)
                            users.append(newUser)
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.delegate?.dataDidUpdate(self, users)
                    }
                }
            }
        }
    }
}

