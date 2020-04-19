//
//  FullPostCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/10/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase

class FullPostCell: UITableViewCell {
    
    static let FullPostCellID = "FullPostCell"
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postStatsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var db = Firestore.firestore()
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
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            let docRef = db.collection("Post/\(post.id!)/Likes").document((user?.email)!)
            docRef.getDocument(source: .cache) { (document, error) in
                if let doc = document
                {
                    if doc.exists {
                        self.likeButton.imageView?.tintColor = .cyan
                    }else
                    {
                        self.likeButton.imageView?.tintColor = .darkGray
                    }
                }else
                {
                    self.likeButton.imageView?.tintColor = .darkGray
                }
            }
    }
    
}
override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
}
@IBAction func buttonPressed(_ sender: UIButton) {
    let action = ButtonPressed(post, sender.tag, self)
    action.update()
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
}

}
