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
    let type : String?
    let parent : UITableViewCell?
    init(_ post: Post, _ type: String, _ parent: UITableViewCell) {
        self.post = post
        self.type = type
        self.parent = parent
    }
    func update(){
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            let uid = user?.uid
            let email = user?.email
            print(uid!)
            print(email!)
        } else {
            let arlert = UIAlertController(title: "Login", message: "you need to log in", preferredStyle: .alert)
            let action = UIAlertAction(title: "Log in", style: .cancel) { (action) in
                DispatchQueue.main.async {
                self.parent?.parentContainerViewController()?.performSegue(withIdentifier: "GotoLogin", sender: self.parent?.parentContainerViewController())
                   
                }
            }
            arlert.addAction(action)
            parent?.parentContainerViewController()?.present(arlert, animated: true, completion: nil)
        }
        
        
    }
}
