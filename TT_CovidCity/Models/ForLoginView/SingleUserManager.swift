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
class SingleUserManager {
    var db = Firestore.firestore()
    var delegate : SingleUserManagerDelegate?
    var id : String?
    init(_ id : String) {
        self.id = id
    }
    func loadData() {
        db.collection("User").document(id!).addSnapshotListener { (documents, err) in
            let data = documents!.data()!
            if let userName = data["UserName"] as? String, let imageURL = data["ImageURL"] as? String, let type = data["Type"] as? String, let address = data["Address"] as? String
            {
                let user = User(userName: userName, imageURL: imageURL, address: address,type: type)
                self.delegate?.dataDidUpdate(self, user)
            } else {
                print("Document does not exist")
            }
        }
    }
}
