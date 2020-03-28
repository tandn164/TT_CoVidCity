//
//  SubTableViewCell.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/24/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit

class SubTableViewCell: UITableViewCell {
    static let subTableViewCellID = "SubTableViewCell"
    @IBOutlet weak var tableView: UITableView!
    var covidmanager = WorldCovidManager()
    var countrydata : [WorldCovidData] = []
  //  var countryInfo : [Country] = []
    var country : Country?
    override func awakeFromNib() {
        super.awakeFromNib()
        covidmanager.delegate = self
        covidmanager.fetCorona()
        print("Manager 19")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = false
        tableView.isScrollEnabled = true
        tableView.register(UINib(nibName: SubCell.subCellID, bundle: nil), forCellReuseIdentifier: SubCell.subCellID)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
//Mark:
extension SubTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Manager 35")
        print(section)
        print(countrydata.count)
        return countrydata.count + 2
  //      return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Manager 43")
        if indexPath.section == 0{
        if let cell = tableView.dequeueReusableCell(withIdentifier: SubCell.subCellID, for: indexPath) as? SubCell {
            if indexPath.row == 0 || indexPath.row == 1{
                cell.Label1.text = "Ten quoc gia"
                cell.Label2.text = "Nhiem"
                cell.Label3.text = "Tu vong"
                cell.Label4.text = "Khoi"
            }
            else
            {
                
                print(indexPath.row)
                cell.Label1.text = countrydata[indexPath.row].countryRegion
                cell.Label2.text = String(countrydata[indexPath.row].confirmed)
                cell.Label3.text = String(countrydata[indexPath.row].deaths)
                cell.Label4.text = String(countrydata[indexPath.row].recovered)
            }
            return cell
            }
            
        }
        return UITableViewCell()
    }
}
extension SubTableViewCell: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
extension SubTableViewCell: WorldCovidDelegate{
    
    func didEnableError(_ error: Error){
        print(error)
    }
    func DataDidUpdate(_ CoronaManager: WorldCovidManager,data: [WorldCovidData]){
        print("Manager 68")
        countrydata = data
        DispatchQueue.main.async{
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
        }
    }
    
}
