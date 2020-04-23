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
    let coronaURL=API.URL
    var delegate : WorldCovidDelegate?
    func fetCorona()
    {
        let urlString=coronaURL
        performRequest(urlString: urlString)
    }
    func  performRequest(urlString: String) {
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didEnableError(error!)
                    return
                }
                if let safeData = data
                {
                    if let coronadata = self.parseJSON(data: safeData)
                    {
                        self.delegate?.DataDidUpdate(self, data: coronadata)
                    }
                    
                }
            }
            task.resume()
        }
    }
    func parseJSON(data: Data) -> [WorldCovidData]?{
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
