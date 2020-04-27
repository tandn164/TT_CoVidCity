//
//  Utilities.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

struct SegueIdentify {
    static let gotoLogin = "GotoLogin"
    static let postResult = "PostResult"
    static let LogintoAdmin = "LogintoAdmin"
    static let LogintoReport = "LogintoReport"
    static let RegistertoReport = "RegistertoReport"
    static let gotoResult = "gotoResult"
    static let ChoosePlace = "ChoosePlace"
    static let searchDetail = "searchDetail"
}
struct Path {
    static func pathToLikes(withID id : String  ) -> String{
        return "Post/\(id)/Likes"
    }
    static func pathToComment(withID id: String) -> String{
        return "Post/\(id)/comment"
    }
    static func pathToVistedLocation(withID id: String) -> String{
        return "User/\(id)/VisitedLocation"
    }
    static let City = "Country/Việt Nam/City"
    static let Hospital = "Contact/CDC/Hospital"
    static let UnitManager = "Contact/CDC/UnitManager"
    static let Top5Hospital = "Contact/CDC/Top5Hospital"
}
struct Database {
    static let post = "Post"
    static let contact = "Contact"
    static let country = "Country"
    static let user = "User"
    struct Contact {
        static let Email = "Email"
        struct Hospital {
            static let Name = "Name"
            static let Phone1 = "Phone1"
            static let Phone2 = "Phone2"
        }
        struct Top5Hospital {
            static let Hospital = "Hospital"
            static let Name = "Name"
        }
        struct UnitManager {
            static let ManagerName = "ManagerName"
            static let Phone = "Phone"
            static let UnitName = "UnitName"
            
        }
    }
    struct Country {
        static let Confirmed = "Confirmed"
        static let Deaths = "Deaths"
        static let Name = "Name"
        static let Recovered = "Recovered"
        struct City {
            static let Confirmed = " Confirmed"
            static let Deaths = "Deaths"
            static let Name = "Name"
            static let Recovered = "Recovered"
        }
    }
    struct Post {
        static let Caption = "Caption"
        static let Image = "Image"
        static let NumberOfLike = "NumberOfLike"
        static let NumberOfComment = "NumberOfComment"
        static let Time = "Time"
        static let User = "User"
        static let UserImage = "Image"
        static let UserName = "Name"
        struct comment {
            static let Comment = "Comment"
            static let Time = "Time"
            static let UserName = "UserName"
            static let UserProfileImage = "UserProfileImage"
        }
    }
    struct User {
        static let Address = "Address"
        static let ImageURL = "ImageURL"
        static let Type1 = "Type"
        static let UserName = "UserName"
        struct VisitedLocation {
            static let locationName = "LocationName"
            static let lat = "lat"
            static let lon = "lon"
        }
    }
}
struct storage {
    static let defaultImageURL = "https://firebasestorage.googleapis.com/v0/b/covidcity-1585012064634.appspot.com/o/profile%2Fadmin%40gmail.com.jpeg?alt=media&token=9a4b1374-d0dc-413a-aa41-0cb75bd29167"
    static let storageRefURL = "gs://covidcity-1585012064634.appspot.com/"
    static let profile = "profile"
    static let post = "post"
    static let contentType = "image/jpg"
    
}
struct Authentication {
    static let admin = "admin@gmail.com"
}
struct API {
    static let URL = "https://covid19.mathdro.id/api/confirmed"
}
