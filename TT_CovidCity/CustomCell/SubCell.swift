//
//  SubCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/28/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class SubCell: UITableViewCell {
    
    @IBOutlet weak var confirmedNum: UILabel!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var deadthNum: UILabel!
    @IBOutlet weak var recoveredNum: UILabel!
    
    static let subCellID = "SubCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
