//
//  PostCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/29/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
protocol PostCellDelegate {
    func didTapped(_ data: Post)
}
class PostCell: UITableViewCell {
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postStatsLabel: UILabel!
    static let PostCellID = "PostCell"
    var delegate : PostCellDelegate?
    var post: Post!{
        didSet{
            UpdateUI()
        }
    }
    func UpdateUI(){
        profileImageView.image = UIImage(named: post.user!.profileImage!)
        userNameLabel.text = post.user!.name
        timeAgoLabel.text = post.time
        captionLabel.text = post.caption
        postImageView.image = UIImage(named: post.image!)
        postStatsLabel.text = "\(post.numberOfLike!) likes     \(post.numberOfComment!) comments"
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabelTap()
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer)
    {
        self.delegate?.didTapped(self.post)
    }
    func setupLabelTap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        let labelTap2 = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.captionLabel.isUserInteractionEnabled = true
        self.captionLabel.addGestureRecognizer(labelTap)
        self.timeAgoLabel.isUserInteractionEnabled = true
        self.timeAgoLabel.addGestureRecognizer(labelTap2)
    }
    @IBAction func buttonPressed(_ sender:UIButton) {
        var title : String
        if sender.tag == 0
        {
            title = "Like"
        }
        else
        {
            title = "Comment"
        }
        let action = ButtonPressed(post, title, self)
        action.update()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
//extension UIView {
//    var parentViewController: UIViewController? {
//        var parentResponder: UIResponder? = self
//        while parentResponder != nil {
//            parentResponder = parentResponder!.next
//            if parentResponder is UIViewController {
//                return parentResponder as? UIViewController
//            }
//        }
//        return nil
//    }
//}
