//
//  SubCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/24/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class SubCell: UITableViewCell {
    static let subCellID = "SubCell"
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Label3: UILabel!
    @IBOutlet weak var Label4: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
