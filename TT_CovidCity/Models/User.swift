//
//  User.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/9/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
struct User {
    let name : String?
    let location : Location?
    let email : String?
    let lon : String?
    let lat : String?
    let profileImage : String?
    let password : String?
    let type : String?
    let visitedLocation : [Location?]
}
struct Location {
    let lat : Float?
    let lon : Float?
}

