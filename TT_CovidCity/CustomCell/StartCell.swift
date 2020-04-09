//
//  StartCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/28/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
protocol StartCellDelegate {
    func buttonPressed(_ button: UIButton)
}
class StartCell: UITableViewCell {
    @IBOutlet weak var hanoiButton: CustomButton!
    @IBOutlet weak var vietnamButton: UIButton!
    @IBOutlet weak var thegioiButton: CustomButton!
    static let startCellID = "StartCell"
    var delegate : StartCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonPressed(_ sender: CustomButton) {
        sender.shake()
        delegate?.buttonPressed(sender)
    }
}
