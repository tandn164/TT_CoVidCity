//
//  CustomViewBorder.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/12/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
import UIKit

class CustomViewCorner: UIView {

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
        setStyle()
    }
    private func setStyle(){
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 15
    }
    
}
