//
//  Country.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/24/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
struct Country {
    var name: String
    var confirmed: Int
    var recovered: Int
    var deaths: Int
    init(_ name: String, _ confirmed: Int,_ recovered: Int,_ deaths: Int ) {
        self.name = name
        self.confirmed = confirmed
        self.recovered = recovered
        self.deaths = deaths
    }
}
