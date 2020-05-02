//
//  SearchView.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/26/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class SearchView: UIView {

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
}
