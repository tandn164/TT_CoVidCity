//
//  WorldCovidData.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/24/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
struct WorldCovidData: Codable{
    let countryRegion: String
    let confirmed: Int
    let recovered: Int
    let deaths: Int
}
