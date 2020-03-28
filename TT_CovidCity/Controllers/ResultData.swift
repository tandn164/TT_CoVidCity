//
//  ResultData.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/25/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
class ResultData: WorldCovidDelegate {
    var cvManager = WorldCovidManager()
    var finalData : [Country] = []
    var worldConfirmed: Int = 0
    var worldRecovered: Int = 0
    var worldDeaths: Int = 0
    init(){
        cvManager.delegate = self
        self.cvManager.fetCorona()
    }
    func didEnableError(_ error: Error) {
        print(error)
    }
    
    func DataDidUpdate(_ CoronaManager: WorldCovidManager, data: [WorldCovidData]) {
        for i in 0..<data.count
        {
            let x = Country(data[i].countryRegion,data[i].confirmed,data[i].recovered,data[i].deaths)
            if let y = isExist(finalData , x) {
                finalData[y].confirmed += x.confirmed
                finalData[y].recovered += x.recovered
                finalData[y].deaths += x.deaths
            } else
            {
            finalData.append(x)
            }
            worldRecovered += x.recovered
            worldConfirmed += x.confirmed
            worldDeaths += x.deaths
        }
        print(finalData.count)
    }
    func isExist(_ country: [Country], _ elements: Country) -> Int? {
        for i in 0..<country.count
        {
            if country[i].name == elements.name
            {
                return i
            }
        }
        return nil
    }
}
