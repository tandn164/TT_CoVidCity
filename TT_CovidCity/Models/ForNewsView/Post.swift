//
//  Posts.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/9/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
struct Post {
    let caption : String?
    let image : String?
    let time : String?
    let numberOfLike : String?
    let numberOfComment : String?
    let user : Writter?
    let id : String?
    
}
struct Comment {
    let comment: String
    let time: String
    let userName: String
    let userProfileImage: String
}
struct Writter {
    let name: String?
    let profileImage: String?
}

