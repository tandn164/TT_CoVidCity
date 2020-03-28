//
//  StartViewCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/27/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
protocol StartViewCellDelegate {
    func buttonPressed(_ button: UIButton)
}
class StartViewCell: UITableViewCell {
    static let startViewCellID = "StartViewCell"
    @IBOutlet weak var confirmedNum: UILabel!
    @IBOutlet weak var deathsNum: UILabel!
    @IBOutlet weak var recoveredNum: UILabel!
    @IBOutlet weak var hanoiButton: UIButton!
    @IBOutlet weak var vietnamButton: UIButton!
    @IBOutlet weak var worldButton: UIButton!
    var delegate : StartViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    @IBAction func hanoiButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(sender)
    }
    @IBAction func vietnamButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(sender)
    }
    @IBAction func worldButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(sender)
    }
    
}
