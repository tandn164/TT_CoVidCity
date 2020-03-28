//
//  ContactCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/28/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    static let contactCellID = "ContactCell"
    @IBOutlet weak var hospitalName: UILabel!
    @IBOutlet weak var phoneNumber1: UILabel!
    @IBOutlet weak var phoneNumber2: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var managerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
