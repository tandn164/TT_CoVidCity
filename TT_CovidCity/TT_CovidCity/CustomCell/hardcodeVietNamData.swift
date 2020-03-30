//
//  hardcodeVietNamData.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/28/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
struct VietNameData {
    var finalData : [Country] = []
    init() {
        var city : Country
        city = Country("Hà Nội", 62, 0, 0)
        self.finalData.append(city)
        city = Country("Hồ Chí Minh", 46, 3, 0)
        self.finalData.append(city)
        city = Country("Vĩnh Phúc", 11 ,11,0)
        self.finalData.append(city)
        city = Country("Bình Thuận", 9, 0, 0)
        self.finalData.append(city)
        city = Country("Quảng Ninh", 7, 0 ,0)
        self.finalData.append(city)
        city = Country("Đà Nẵng", 6, 3, 0)
        self.finalData.append(city)
        city = Country("Bắc Giang", 5, 0, 0)
        self.finalData.append(city)
        city = Country("bạc Liêu", 4, 0, 0)
        self.finalData.append(city)
        city = Country("Đồng Tháp", 4, 0, 0)
        self.finalData.append(city)
        
    }
}
