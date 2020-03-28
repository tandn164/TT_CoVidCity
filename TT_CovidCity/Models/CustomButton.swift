//
//  CustomButton.swift
//  TT_CovidCity
//
//  Created by Trần Nhất Thống on 3/27/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

@IBDesignable
final class CustomButton: UIButton {
  
  var borderWidth: CGFloat = 2.0
  var borderColor = UIColor.white.cgColor
  
  @IBInspectable var titleText: String? {
    didSet {
      self.setTitle(titleText, for: .normal)
      self.setTitleColor(UIColor.black,for: .normal)
    }
  }
  
  override init(frame: CGRect){
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setup()
  }
  
  func setup() {
    self.clipsToBounds = true
    self.layer.cornerRadius = self.frame.size.width / 2.25
    self.layer.borderColor = borderColor
    self.layer.borderWidth = borderWidth
  }
}
