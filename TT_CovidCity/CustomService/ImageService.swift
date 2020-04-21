//
//  ImageService.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/22/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
class ImageService{
    static func downloadImage(withURL url: URL, completion: @escaping (_ image : UIImage? ) -> ()){
        let dataTask = URLSession.shared.dataTask(with: url) { (data, url, error) in
            var downloadedImage : UIImage?
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
}
