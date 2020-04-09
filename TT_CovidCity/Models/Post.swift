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
}
struct Writter {
    let name: String?
    let profileImage: String?
}

