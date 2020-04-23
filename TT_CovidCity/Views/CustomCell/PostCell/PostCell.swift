//
//  PostCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/29/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase
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
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    static let PostCellID = "PostCell"
    var db = Firestore.firestore()
    var delegate : PostCellDelegate?
    var post: Post!{
        didSet{
            UpdateUI()
        }
    }
    func UpdateUI(){
        ImageService.downloadImage(withURL: URL(string: post.user!.profileImage!)!) { (image) in
            self.profileImageView.image = image
        }
        userNameLabel.text = post.user!.name
        timeAgoLabel.text = String("\(post.time!)")
        captionLabel.text = post.caption
        postImageView.image = UIImage(named: post.image!)
        postStatsLabel.text = "\(post.numberOfLike!) likes     \(post.numberOfComment!) comments"
        if Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            let docRef = db.collection(Path.pathToLikes(withID: post.id!)).document((user?.email)!)
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
        } else
        {
            self.likeButton.imageView?.tintColor = .darkGray
        }
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
        let action = ButtonPressed(post, sender.tag, self)
        action.update()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
