//
//  StartCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/26/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class StartCell: UITableViewCell {
    static let StartCellID = "startCell"
    @IBOutlet weak var recoveredNum: UILabel!
    @IBOutlet weak var deathsNum: UILabel!
    @IBOutlet weak var confirmedNum: UILabel!
    @IBOutlet weak var hanoiButton: UIButton!
    @IBOutlet weak var vietnamButton: UIButton!
    @IBOutlet weak var worldButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
