//
//  FullPostCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/10/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class FullPostCell: UITableViewCell {

    static let FullPostCellID = "FullPostCell"
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postStatsLabel: UILabel!
    var post: Post!{
        didSet{
            UpdateUI()
        }
    }
    func UpdateUI(){
        timeAgoLabel.text = post.time
        profileImageView.image = UIImage(named: post.user!.profileImage!)
        userNameLabel.text = post.user!.name
        captionLabel.text = post.caption
        postImageView.image = UIImage(named: post.image!)
        postStatsLabel.text = "\(post.numberOfLike!) likes"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
