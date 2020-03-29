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
class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataToPass : [Country] = []
          var rsdata = ResultData()
    var hardContactData  = ContactData()
    var hardVietNamData = VietNameData()
    var tableData = [DropDownCellData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTable()
      
        self.tabBarItem.selectedImage = UIImage.init(systemName: "doc.text.fill")
    }
    func setupData(){
        tableData = hardContactData.finalData
    }
    func setupTable(){
        tableView.register(UINib(nibName: StartCell.startCellID, bundle: nil), forCellReuseIdentifier: StartCell.startCellID)
        tableView.register(UINib(nibName: ContactCell.contactCellID, bundle: nil), forCellReuseIdentifier: ContactCell.contactCellID)
    }
}
extension DetailViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
}
extension DetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1,2,3:
            if tableData[section-1].open == true {
                return tableData[section-1].sectionData.count+1
            }
            else{
                return 1
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StartCell.startCellID, for: indexPath) as? StartCell
            {
                cell.delegate = self
                return cell
            }
        case 1,2,3:
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
        default:
            return UITableViewCell()
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 15
       }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          
           if indexPath.section == 0 {
               return 230
           } else {
           return 60
        }
       }
    
}
extension DetailViewController: StartCellDelegate{
    func buttonPressed(_ button: UIButton) {
        switch button.tag {
        case 1:
            dataToPass = hardVietNamData.finalData
        case 3:
            print(rsdata.finalData.count)
            dataToPass = rsdata.finalData
        default:
            break
        }
        self.performSegue(withIdentifier: "gotoResult", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "gotoResult"
              {
                let destinationMV = segue.destination as! DetailInfoView
                destinationMV.data = dataToPass
              }
    }
}
