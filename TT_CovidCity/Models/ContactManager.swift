//
//  hardcodeContactData.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/28/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import Foundation
import Firebase
protocol ContactDelegate{
    func DataDidUpdate(_ ContactManager: ContactManager,_ data: [DropDownCellData] )
}
struct ContactManager {
    var db = Firestore.firestore()
    var delegate : ContactDelegate?
    func loadContact1(){
        print(41)
        db.collection("Contact/CDC/Hospital").addSnapshotListener { (querySnapshot, error) in
            print(43)
            var tableData : [DropDownCellData] = []
            var contact1 : [Contact] = []
            if let err = error {
                print("not read OK \(err)")
            }
            else {
                if let snapShotDocuments = querySnapshot?.documents
                {
                    for doc in snapShotDocuments {
                        let data = doc.data()
                        if let name = data["Name"] as? String, let phone1 = data["Phone1"] as? String, let phone2 = data["Phone2"] as? String
                        {
                            print(55)
                            let newContact = Contact(hospitalName: name, managerName: "", phoneNumber1: phone1, phoneNumber2: phone2)
                            contact1.append(newContact)
                        }
                        
                    }
                }
            }
            tableData.append(DropDownCellData(open: false, title: "Các bệnh viện và trung tâm kiểm soát bênh tật", sectionData: contact1))
            let db1 = Firestore.firestore()
            db1.collection("Contact/CDC/UnitManager").addSnapshotListener { (querySnapshot, error) in
                var contact2 : [Contact] = []
                if let err = error {
                    print("not read OK \(err)")
                }
                else {
                    if let snapShotDocuments = querySnapshot?.documents
                    {
                        for doc in snapShotDocuments {
                            let data = doc.data()
                            if let Unitname = data["UnitName"] as? String, let managerName = data["ManagerName"] as? String, let phone = data["Phone"] as? String
                            {
                                let newContact = Contact(hospitalName: Unitname, managerName: managerName, phoneNumber1: phone, phoneNumber2: "")
                                contact2.append(newContact)
                            }
                            
                        }
                    }
                }
                tableData.append(DropDownCellData(open: false, title: "Danh sách liên hệ các lãnh đạo đơn vị", sectionData: contact2))
                let db2 = Firestore.firestore()
                db2.collection("Contact/CDC/UnitManager").addSnapshotListener { (querySnapshot, error) in
                           var contact3 : [Contact] = []
                           if let err = error {
                               print("not read OK \(err)")
                           }
                           else {
                               if let snapShotDocuments = querySnapshot?.documents
                               {
                                   for doc in snapShotDocuments {
                                       let data = doc.data()
                                       if let Unitname = data["UnitName"] as? String, let managerName = data["ManagerName"] as? String, let phone = data["Phone"] as? String
                                       {
                                           let newContact = Contact(hospitalName: Unitname, managerName: managerName, phoneNumber1: phone, phoneNumber2: "")
                                           contact3.append(newContact)
                                       }
                                       
                                   }
                               }
                           }
                           tableData.append(DropDownCellData(open: false, title: "5 bệnh viện tiếp nhận cách ly, theo dõi và điều trị", sectionData: contact3))
                           DispatchQueue.main.async {
                            self.delegate?.DataDidUpdate(self, tableData)
                           }
                       }
            }
        }
        print(69)
    }
    
}
struct DropDownCellData {
    var open = Bool()
    var title = String()
    var sectionData = [Contact]()
}

