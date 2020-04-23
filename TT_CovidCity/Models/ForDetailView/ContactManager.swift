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
        db.collection(Path.Hospital).addSnapshotListener { (querySnapshot, error) in
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
                        if let name = data[Database.Contact.Hospital.Name] as? String, let phone1 = data[Database.Contact.Hospital.Phone1] as? String, let phone2 = data[Database.Contact.Hospital.Phone2] as? String
                        {
                            let newContact = Contact(hospitalName: name, managerName: "", phoneNumber1: phone1, phoneNumber2: phone2)
                            contact1.append(newContact)
                        }
                        
                    }
                }
            }
            tableData.append(DropDownCellData(open: false, title: "Các bệnh viện và trung tâm kiểm soát bênh tật", sectionData: contact1))
            let db1 = Firestore.firestore()
            db1.collection(Path.UnitManager).addSnapshotListener { (querySnapshot, error) in
                var contact2 : [Contact] = []
                if let err = error {
                    print("not read OK \(err)")
                }
                else {
                    if let snapShotDocuments = querySnapshot?.documents
                    {
                        for doc in snapShotDocuments {
                            let data = doc.data()
                            if let Unitname = data[Database.Contact.UnitManager.UnitName] as? String, let managerName = data[Database.Contact.UnitManager.ManagerName] as? String, let phone = data[Database.Contact.UnitManager.Phone] as? String
                            {
                                let newContact = Contact(hospitalName: Unitname, managerName: managerName, phoneNumber1: phone, phoneNumber2: "")
                                contact2.append(newContact)
                            }
                            
                        }
                    }
                }
                tableData.append(DropDownCellData(open: false, title: "Danh sách liên hệ các lãnh đạo đơn vị", sectionData: contact2))
                let db2 = Firestore.firestore()
                db2.collection(Path.Top5Hospital).addSnapshotListener { (querySnapshot, error) in
                           var contact3 : [Contact] = []
                           if let err = error {
                               print("not read OK \(err)")
                           }
                           else {
                               if let snapShotDocuments = querySnapshot?.documents
                               {
                                   for doc in snapShotDocuments {
                                       let data = doc.data()
                                    if let name = data[Database.Contact.Top5Hospital.Name] as? String,let hospital = data[Database.Contact.Top5Hospital.Hospital] as? String
                                       {
                                           let newContact = Contact(hospitalName: name, managerName: "", phoneNumber1: hospital , phoneNumber2: "")
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
    }
    
}
struct DropDownCellData {
    var open = Bool()
    var title = String()
    var sectionData = [Contact]()
}

