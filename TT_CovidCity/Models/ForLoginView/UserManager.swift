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
struct UserManager {
    var delegate : UserManagerDelegate?
    var db = Firestore.firestore()
    func loadData() {
        db.collection(Database.user).addSnapshotListener { (querySnapshot, error) in
            var users : [User] = []

            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments {
                    let data = doc.data()
                        if let userName = data[Database.User.UserName] as? String, let imageURL = data[Database.User.ImageURL] as? String, let type = data[Database.User.Type1] as? String, let address = data[Database.User.Address] as? String
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

