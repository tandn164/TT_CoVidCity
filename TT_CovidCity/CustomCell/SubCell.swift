//
//  SubCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/25/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
class SubCell: UITableViewCell {
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label0: UILabel!
    static let SubCellID = "subCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
