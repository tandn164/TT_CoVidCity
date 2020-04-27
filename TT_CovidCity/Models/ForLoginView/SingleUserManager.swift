//
//  SingleUserManager.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
import Firebase
protocol SingleUserManagerDelegate {
    func dataDidUpdate(_ sender: SingleUserManager, _ data: User)
}
struct SingleUserManager {
    var db = Firestore.firestore()
    var delegate : SingleUserManagerDelegate?
    var id : String?
    init(_ id : String) {
        self.id = id
    }
    func loadData() {
        db.collection(Database.user).document(id!).addSnapshotListener { (documents, err) in
            guard let data = documents?.data() else{
                print("Get user process get error")
                return
            }
            if let userName = data[Database.User.UserName] as? String, let imageURL = data[Database.User.ImageURL] as? String, let type = data[Database.User.Type1] as? String, let address = data[Database.User.Address] as? String
            {
                let user = User(userName: userName, imageURL: imageURL, address: address,type: type)
                self.delegate?.dataDidUpdate(self, user)
            } else {
                print("Document does not exist")
            }
        }
    }
}
