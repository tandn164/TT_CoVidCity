//
//  OrangeButton.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 5/1/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class OrangeButton: UIButton {

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
        backgroundColor = UIColor.systemOrange
      layer.cornerRadius = layer.frame.width / 2
    }
    private func setShadow(){
        layer.shadowColor = UIColor.systemOrange.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
