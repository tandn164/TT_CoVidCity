//
//  MarkerCluster.swift
//  TT_CovidCity
//
//  Created by Trần Nhất Thống on 3/24/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import CoreLocation
import GoogleMaps
import GoogleMapsUtils

class POIItem: NSObject, GMUClusterItem  {
    
    var position: CLLocationCoordinate2D
    var name: String!
    init(position: CLLocationCoordinate2D, name: String) {
        self.position = position
        self.name = name
    }
}
