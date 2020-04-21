//
//  ContactResultData.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 4/9/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
class ContactResultData: ContactDelegate {
    
    var ctManager = ContactManager()
    var finalData : [DropDownCellData] = []
    init(){
        ctManager.delegate = self
        self.ctManager.loadContact1()
    }
    func didEnableError(_ error: Error) {
        print(error)
    }
    func DataDidUpdate(_ ContactManager: ContactManager, _ data: [DropDownCellData]) {
           finalData = data
       }
}
