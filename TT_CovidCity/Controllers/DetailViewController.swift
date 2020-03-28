//
//  SecondViewController.swift
//  abc
//
//  Created by Trần Nhất Thống on 3/22/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
struct DropDownCellData {
    var open = Bool()
    var title = String()
    var sectionData = [Contact]()
}
enum SectionType: Int{
    case start
    case table
    case contact
}
class DetailViewController: UIViewController {
    var tableData = [DropDownCellData]()
    var contactData = [Contact]()
    @IBOutlet weak var tableView: UITableView!
    var rsdata = ResultData()
    var finalData : [Country] = []
    var worldConfirmed: Int = 0
    var worldRecovered: Int = 0
    var worldDeaths: Int = 0
    override func viewDidLoad() {
        //rsdata = ResultData()
        super.viewDidLoad()
        setupData()
        setupTableView()
        self.tabBarItem.selectedImage = UIImage.init(systemName: "doc.text.fill")
    }
    
}
extension DetailViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFatherTable(tableView) {
            return 5
        } else
        {
            return 1
        }
    }
}
extension DetailViewController: UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView.tag == 100 {
        switch section {
        case 0,1:
            return 1
        case 2,3,4:
            if tableData[section-2].open == true {
                return tableData[section-2].sectionData.count+1
            }
            else{
                return 1
            }
        default:
            return 0
        }
    } else{
        return finalData.count+1
    }
}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFatherTable(tableView) {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: StartViewCell.startViewCellID, for: indexPath) as! StartViewCell
                cell.delegate = self
                cell.confirmedNum.text = String(worldConfirmed)
                cell.recoveredNum.text = String(worldRecovered)
                cell.deathsNum.text = String(worldDeaths)
                return cell
            case 1:
//                let cell = tableView.dequeueReusableCell(withIdentifier: SubViewTableCell.subViewTableCellID, for: indexPath) as! SubViewTableCell
                let cell = tableView.dequeueReusableCell(withIdentifier: "subTableViewCell", for: indexPath)
                return cell
            case 2,3,4:
                let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.contactCellID, for: indexPath) as! ContactCell
                if indexPath.row == 0 {
                    cell.button1.isHidden = false
                    cell.phoneNumber1.text = ""
                    cell.phoneNumber2.text = ""
                    cell.managerName.text = ""
                    cell.hospitalName.text = tableData[indexPath.section-2].title
                }
                else{
                    cell.button1.isHidden = true
                    cell.phoneNumber1.text = tableData[indexPath.section-2].sectionData[indexPath.row-1].phoneNumber1
                    cell.phoneNumber2.text = tableData[indexPath.section-2].sectionData[indexPath.row-1].phoneNumber2
                    cell.hospitalName.text = tableData[indexPath.section-2].sectionData[indexPath.row-1].hospitalName
                    cell.managerName.text = tableData[indexPath.section-2].sectionData[indexPath.row-1].managerName
                }
                return cell
            default:
                break
            }
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: SubCell.SubCellID, for: indexPath) as! SubCell
            if indexPath.row == 0
            {
                cell.label0.text = "Tên quốc gia"
                cell.label1.text = "Nhiễm"
                cell.label2.text = "Tử vong"
                cell.label3.text = "Hồi phục"
                cell.backgroundColor = .none
            }else {
                cell.label0.text = rsdata.finalData[indexPath.row-1].name
                cell.label1.text = String(finalData[indexPath.row-1].confirmed)
                cell.label2.text = String(finalData[indexPath.row-1].deaths)
                cell.label3.text = String(finalData[indexPath.row-1].recovered)
                if (indexPath.row-1)%2 == 0 {
                    cell.backgroundColor = .opaqueSeparator
                } else
                {
                    cell.backgroundColor = .none
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFatherTable(tableView) {
            if indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4{
                if tableData[indexPath.section-2].open == true{
                    tableData[indexPath.section-2].open = false
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .none)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                } else{
                    tableData[indexPath.section-2].open = true
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .none)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isFatherTable(tableView)
        {
            return 10
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && isFatherTable(tableView){
            return 400
            
        }
        if indexPath.section == 0 && isFatherTable(tableView){
            return 250
        }
        return 50
    }
}

extension DetailViewController{
    func isFatherTable(_ tableView: UITableView) -> Bool{
        if tableView.tag == 100
        {
            return true
            
        }
        return false
    }
    func setupData(){
        finalData = rsdata.finalData
        worldDeaths = rsdata.worldDeaths
        worldConfirmed = rsdata.worldConfirmed
        worldRecovered = rsdata.worldRecovered
    }
    func setupTableView() {
        tableView.register(UINib(nibName: StartViewCell.startViewCellID, bundle: nil), forCellReuseIdentifier: StartViewCell.startViewCellID)
        tableView.register(UINib(nibName: ContactCell.contactCellID, bundle: nil), forCellReuseIdentifier: ContactCell.contactCellID)
        hardcodeData()
    }
    func hardcodeData() {
        contactData = [Contact(hospitalName: "Bach mai", managerName: "", phoneNumber1: "0966677271", phoneNumber2: "174520870"),
        Contact(hospitalName: "Nhiet doi trung uong", managerName: "", phoneNumber1: "012345678", phoneNumber2: "87654321"),
        Contact(hospitalName: "Benh vien tinh Ha Noi", managerName: "", phoneNumber1: "888888888", phoneNumber2: "000000000")]
        tableData = [DropDownCellData(open: false, title: "Thong tin cac benh vien tiep nhan benh nhan", sectionData: contactData),
                     DropDownCellData(open: false, title: "Thong tin cac benh vien tiep nhan benh nhan", sectionData:  contactData),
                     DropDownCellData(open: false, title: "Thong tin cac benh vien tiep nhan benh nhan", sectionData: contactData)]
    }
}
extension DetailViewController: StartViewCellDelegate{
    func buttonPressed(_ button: UIButton){
        
    }
}
