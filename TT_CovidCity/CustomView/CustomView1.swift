//
//  CustomView.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/29/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class CustomView1: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    func setupView() {
        setShadow()
        setStyle()
    }
    private func setStyle(){
        backgroundColor = UIColor.white
    }
    private func setShadow(){
        layer.shadowColor = UIColor.opaqueSeparator.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
