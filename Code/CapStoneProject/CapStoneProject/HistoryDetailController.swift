//
//  HistoryDetailController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/3.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var dateList:[String] = []
var typeList:[String] = []
var beforeList:[String] = []
var afterList:[String] = []

class HistoryDetailController: UITableViewController {

    var mPresenter = HistoryDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        
        dateList.removeAll()
        typeList.removeAll()
        beforeList.removeAll()
        afterList.removeAll()
        
        mPresenter.getInfo()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dateList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyItem", for: indexPath) as! HistoryDetailCell

        cell.label_changeDate.text = dateList[indexPath.row]
        cell.label_changeType.text = typeList[indexPath.row]
        cell.label_beforeChange.text = beforeList[indexPath.row]
        cell.label_afterChange.text = afterList[indexPath.row]

        return cell
    }
}

extension HistoryDetailController: HistoryDetailView {
    func initList() {
        self.tableView.reloadData()
    }
}
