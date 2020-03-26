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
    var sectionData = [String]()
}
class DetailViewController: UIViewController {
    var arr = ["Tan", "Thu", "Thong", "Huyen"]
    var tableData = [DropDownCellData]()
    @IBOutlet weak var tableView: UITableView!
    let rsdata = ResultData()
    var anotherData : [Country] = []
    var worldConfirmed: Int = 0
    var worldRecovered: Int = 0
    var worldDeaths: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        anotherData = rsdata.finalData
        worldSumary()
        tableData = [DropDownCellData(open: false, title: "cell1", sectionData: ["ahihi","ohoho","ehehe"]),
                    DropDownCellData(open: false, title: "cell2", sectionData:  ["ahihi","ohoho","ehehe"]),
                    DropDownCellData(open: false, title: "cell3", sectionData:  ["ahihi","ohoho","ehehe"])]
        self.tabBarItem.selectedImage = UIImage.init(systemName: "doc.text.fill")
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        
    }
    func worldSumary() {
        for i in 0..<anotherData.count
        {
            worldConfirmed += anotherData[i].confirmed
            worldRecovered += anotherData[i].recovered
            worldDeaths += anotherData[i].deaths
        }
    }
    
}
extension DetailViewController: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 100 {
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
                    print("ok")
                    return tableData[section-2].sectionData.count+1
                }
                else{
                    return 1
                }
            default:
                return 0
            }
        } else{
            return anotherData.count+1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 100 {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: StartCell.StartCellID, for: indexPath) as! StartCell
                cell.confirmedNum.text = String(worldConfirmed)
                cell.recoveredNum.text = String(worldRecovered)
                cell.deathsNum.text = String(worldDeaths)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "subTableViewCell", for: indexPath)
                return cell
            case 2,3,4:
                if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
                    cell.textLabel?.text = tableData[indexPath.section-2].title
                    return cell
                }
                else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
                    cell.textLabel?.text = tableData[indexPath.section-2].sectionData[indexPath.row-1]
                    return cell
                }
                
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
                cell.label0.text = anotherData[indexPath.row-1].name
                cell.label1.text = String(anotherData[indexPath.row-1].confirmed)
                cell.label2.text = String(anotherData[indexPath.row-1].deaths)
                cell.label3.text = String(anotherData[indexPath.row-1].recovered)
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
        if tableView.tag == 100 {
            if indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4{
                if tableData[indexPath.section-2].open == true{
                    tableData[indexPath.section-2].open = false
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .none)
                } else{
                    tableData[indexPath.section-2].open = true
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .none)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView.tag == 100
        {
            return 10
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && tableView.tag == 100 {
            return 400
            
        }
        if indexPath.section == 0 && tableView.tag == 100 {
            return 250
        }
        return 50
    }
}

