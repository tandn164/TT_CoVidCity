//
//  UtilitiesFunction.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/23/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import GoogleMaps
import GooglePlaces
import Firebase
import IQKeyboardManagerSwift

struct GMSSetup {
    static func provideAPIKey(){
       //GMSServices.provideAPIKey("AIzaSyDTodDbsCkNQieBXiHmUg6O0Hd_mffbKac")
        //GMSPlacesClient.provideAPIKey("AIzaSyDTodDbsCkNQieBXiHmUg6O0Hd_mffbKac")
        GMSServices.provideAPIKey("AIzaSyAsVdJwU6GfnCj2KHC-r7TkicqR6aXbY1I")
        GMSPlacesClient.provideAPIKey("AIzaSyAsVdJwU6GfnCj2KHC-r7TkicqR6aXbY1I")
    }
}
struct AppwillBegin {
    static func reLogin(){
        do {
          try Auth.auth().signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        IQKeyboardManager.shared.enable = true
    }
}
