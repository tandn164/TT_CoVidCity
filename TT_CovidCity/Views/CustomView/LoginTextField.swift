//
//  CustomLoginView.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/20/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class LoginTextField: UIView {

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
        setShadow()
      setBorder()
    }
    private func setStyle(){
        backgroundColor = UIColor.clear
        layer.cornerRadius = 10
    }
    private func setShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.3
        clipsToBounds = true
        layer.masksToBounds = false
    }
  
  private func setBorder(){
    layer.borderWidth = 1
    layer.borderColor = UIColor.black.cgColor
  }
    
}
