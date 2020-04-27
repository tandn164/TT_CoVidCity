//
//  GrayButton.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/27/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class GrayButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    func setupButton() {
        setShadow()
        setStyle()
    }
    private func setStyle(){
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.systemGray
        titleLabel?.font = UIFont(name: "System", size: 15)
        layer.cornerRadius = 8
    }
    private func setShadow(){
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
    func shake(){
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 8, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 8, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }
}
