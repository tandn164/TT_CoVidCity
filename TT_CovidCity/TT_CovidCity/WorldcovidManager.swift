//
//  WorldcovidManager.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/24/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
protocol WorldCovidDelegate {
    func didEnableError(_ error: Error)
    func DataDidUpdate(_ CoronaManager: WorldCovidManager,data: [WorldCovidData])
}
struct WorldCovidManager {
    let coronaURL="https://covid19.mathdro.id/api/confirmed"
    var delegate : WorldCovidDelegate?
    func fetCorona()
    {
        let urlString=coronaURL
        performRequest(urlString: urlString)
    }
    func  performRequest(urlString: String) {
        print("Data 23")
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                print("Data 28")
                if error != nil{
                    self.delegate?.didEnableError(error!)
                    return
                }
                
                if let safeData = data
                {
                    if let coronadata = self.parseJSON(data: safeData)
                    {
                        print("Data 38")
                        print(coronadata.count)
                        self.delegate?.DataDidUpdate(self, data: coronadata)
                    }
                    
                }
            }
            print("Data 44")
            task.resume()
        }
    }
    func parseJSON(data: Data) -> [WorldCovidData]?{
        print("Data 49")
        let decoder = JSONDecoder()
        do{
            let decoderData = try decoder.decode([WorldCovidData].self, from: data)
            
            return decoderData
        } catch{
            delegate?.didEnableError(error)
            return nil
        }
    }
}
