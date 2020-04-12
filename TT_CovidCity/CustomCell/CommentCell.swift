//
//  CommentCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/12/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    static let CommentCellID = "CommentCell"
    var comment: Comment!{
        didSet{
            UpdateUI()
        }
    }
    func UpdateUI(){
        userImage.image = UIImage(named: comment.userProfileImage)
        userName.text = comment.userName
        userComment.text = comment.comment
        timeAgo.text = comment.time
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
