//
//  SecondViewController.swift
//  abc
//
//  Created by Trần Nhất Thống on 3/22/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
import Firebase
// MARK: - Special datatype
enum SectionType: Int {
    case start
    case contact1
    case contact2
    case contact3
    // Chưa nghĩ ra cách tạo DropMenu có title cell nằm bất kì trong section nên phải tạo 3 section contact để title cell luôn ở đầu.
}
// MARK: - Main
class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataToPass : [Country] = []
    var rsdata = ResultData()
    var ctrsdata = ContactResultData()
    var columnName : String?
    var tableData : [DropDownCellData] = []
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        tableData = ctrsdata.finalData
        self.tabBarItem.selectedImage = UIImage.init(systemName: "doc.text.fill")
    }
    func setupTable(){
        tableView.register(UINib(nibName: StartCell.startCellID, bundle: nil), forCellReuseIdentifier: StartCell.startCellID)
        tableView.register(UINib(nibName: ContactCell.contactCellID, bundle: nil), forCellReuseIdentifier: ContactCell.contactCellID)
    }
    
}
// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        print(129)
        return 4
    }
}
// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _section = SectionType(rawValue: section){
            switch _section {
            case .start:
                return 1
            case .contact1,.contact2,.contact3:
                if tableData[section-1].open == true {
                    return tableData[section-1].sectionData.count+1
                }
                else{
                    return 1
                }
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let _section = SectionType(rawValue: indexPath.section){
            switch _section {
            case .start:
                if let cell = tableView.dequeueReusableCell(withIdentifier: StartCell.startCellID, for: indexPath) as? StartCell
                {
                    cell.delegate = self
                    return cell
                }
            case .contact1,.contact2,.contact3:
                if let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.contactCellID, for: indexPath) as? ContactCell
                {
                    if indexPath.row == 0 {
                        cell.button.isHidden = false
                        cell.phoneNumber1.text = ""
                        cell.phoneNumber2.text = ""
                        cell.managerName.text = ""
                        cell.hospitalName.text = tableData[indexPath.section-1].title
                    }
                    else{
                        cell.button.isHidden = true
                        cell.phoneNumber1.text = tableData[indexPath.section-1].sectionData[indexPath.row-1].phoneNumber1
                        cell.phoneNumber2.text = tableData[indexPath.section-1].sectionData[indexPath.row-1].phoneNumber2
                        cell.hospitalName.text = tableData[indexPath.section-1].sectionData[indexPath.row-1].hospitalName
                        cell.managerName.text = tableData[indexPath.section-1].sectionData[indexPath.row-1].managerName
                    }
                    return cell
                }
                
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3{
            if tableData[indexPath.section-1].open == true{
                tableData[indexPath.section-1].open = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .none)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            } else{
                tableData[indexPath.section-1].open = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .none)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
        tableView.endUpdates()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 230
        } else {
            if indexPath.row == 0{
                return 70
            }
            return 80
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0{
            let view = CustomView1()
            return view
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 0
        }
        return 15
    }
}
// MARK: - StartCellDelegate
extension DetailViewController: StartCellDelegate{
    func buttonPressed(_ button: UIButton) {
        switch button.tag {
        case 1:
            //  dataToPass = hardVietNamData.finalData
            db.collection("Country/Việt Nam/City").addSnapshotListener { (querySnapshot, error) in
                self.dataToPass = []
                
                if let err = error {
                    print("not read OK \(err)")
                }
                else {
                    if let snapShotDocuments = querySnapshot?.documents
                    {
                        
                        for doc in snapShotDocuments {
                            let data = doc.data()
                            if let name = data["Name"] as? String, let confirmed = data["Confirmed"] as? String, let deaths = data["Deaths"] as? String, let recovered = data["Recovered"] as? String
                            {
                                let newCity = Country(name, Int(confirmed) ?? 0, Int(recovered) ?? 0, Int(deaths) ?? 0)
                                self.dataToPass.append(newCity)
                            }
                            
                        }
                    }
                }
                self.columnName = "Tên thành phố"
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "gotoResult", sender: self)
                }
            }
            
        case 3:
            print(rsdata.finalData.count)
            dataToPass = rsdata.finalData
            columnName = "Tên quốc gia"
            self.performSegue(withIdentifier: "gotoResult", sender: self)
        default:
            break
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoResult"
        {
            let destinationMV = segue.destination as! DetailInfoView
            destinationMV.data = dataToPass
            destinationMV.columnName = columnName
        }
    }
}
