//
//  VisitedLocationManager.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/27/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
import Firebase
protocol VisitedLocationManagerDelegate {
    func dataDidUpdate(_ sender: VisitedLocationManager, _ data : [VisitedLocation] )
}
struct VisitedLocationManager {
    var delegate : VisitedLocationManagerDelegate?
    var db = Firestore.firestore()
    var id : String?
    init(_ id: String) {
        self.id = id
    }
    func loadData() {
        db.collection(Path.pathToVistedLocation(withID: id!)).addSnapshotListener { (querySnapshot, error) in
            var locations : [VisitedLocation] = []

            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments {
                    let data = doc.data()
                        if let locationName = data[Database.User.VisitedLocation.locationName] as? String, let lat = data[Database.User.VisitedLocation.lat] as? Double, let lon = data[Database.User.VisitedLocation.lon] as? Double
                        {
                            let location = VisitedLocation(locationAddress: locationName, lat: lat, lon: lon)
                            locations.append(location)
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self.delegate?.dataDidUpdate(self, locations)
                    }
                }
            }
        }
    }
}
