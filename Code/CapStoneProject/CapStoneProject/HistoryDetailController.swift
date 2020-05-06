//
//  HistoryDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/3.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var historyDateList:[String] = []
var historyTypeList:[String] = []
var historyBeforeList:[String] = []
var historyAfterList:[String] = []

class HistoryDetailController: UITableViewController {

    var mPresenter = HistoryDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        
        historyDateList.removeAll()
        historyTypeList.removeAll()
        historyBeforeList.removeAll()
        historyAfterList.removeAll()
        mPresenter.getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.addSubview(homeButton)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        homeButton.removeFromSuperview()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyDateList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyItem", for: indexPath) as! HistoryDetailCell

        cell.label_changeDate.text = historyDateList[indexPath.row]
        cell.label_changeType.text = historyTypeList[indexPath.row]
        cell.label_beforeChange.text = historyBeforeList[indexPath.row]
        cell.label_afterChange.text = historyAfterList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HistoryDetailController: HistoryDetailView {
    func initList() {
        if(historyDateList.count == 0){
            let label = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 21)
            label.backgroundColor = .gray
            label.textColor = .white
            label.text = "暂无数据"
            label.textAlignment = .center
            tableView.tableFooterView = label
        }
        else {
            self.tableView.reloadData()
        }
    }
}
