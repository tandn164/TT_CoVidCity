//
//  DetailInfoView.swift
//  TT_CovidCity
//
//  Created by Nguyễn Đức Tân on 3/28/20.
//  Copyright © 2020 Trần Nhất Thống. All rights reserved.
//

import UIKit
// MARK: - Main
class DetailInfoView: UIViewController {
    @IBOutlet weak var deathNum: UILabel!
    @IBOutlet weak var recoveredNum: UILabel!
    @IBOutlet weak var confirmedNum: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var data : [Country] = []
    var worldConfirmed = 0
    var worldDeaths = 0
    var worldRecovered = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupTable()
        deathNum.text = String(worldDeaths)
        confirmedNum.text = String(worldConfirmed)
        recoveredNum.text = String(worldRecovered)
    }
    func setupData() {
        for i in data{
            worldDeaths += i.deaths
            worldConfirmed += i.confirmed
            worldRecovered += i.recovered
        }
    }
    func setupTable()  {
        tableView.register(UINib(nibName: SubCell.subCellID, bundle: nil), forCellReuseIdentifier: SubCell.subCellID)
    }
}
// MARK: - UITableViewDelegate
extension DetailInfoView: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
// MARK: - UITableViewDataSource
extension DetailInfoView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SubCell.subCellID, for: indexPath) as? SubCell{
            if indexPath.row == 0
            {
                cell.countryName.text = "Tên quốc gia"
                cell.confirmedNum.text = "Nhiễm"
                cell.deadthNum.text = "Tử vong"
                cell.recoveredNum.text = "Hồi phục"
                cell.backgroundColor = .none
            }else {
                cell.countryName.text = data[indexPath.row-1].name
                cell.confirmedNum.text = String(data[indexPath.row-1].confirmed)
                cell.deadthNum.text = String(data[indexPath.row-1].deaths)
                cell.recoveredNum.text = String(data[indexPath.row-1].recovered)
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
