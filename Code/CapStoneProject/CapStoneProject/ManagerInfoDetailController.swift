//
//  ManagerInfoController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/4.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var ManagerInfoNameList:[String] = []
var ManagerInfoPositionList:[String] = []
var ManagerInfoIntroductionList:[String] = []

class ManagerInfoDetailController: UITableViewController {

    var mPresenter = ManagerInfoDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        
        ManagerInfoNameList.removeAll()
        ManagerInfoPositionList.removeAll()
        ManagerInfoIntroductionList.removeAll()
        mPresenter.getInfo()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ManagerInfoNameList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "managerInfoItem", for: indexPath) as! ManagerInfoDetailCell

        cell.label_managerName.text = ManagerInfoNameList[indexPath.row]
        cell.label_position.text = ManagerInfoPositionList[indexPath.row]
        cell.label_introductionInfo.text = ManagerInfoIntroductionList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ManagerInfoDetailController: ManagerInfoDetailView {
    func initList() {
        self.tableView.reloadData()
    }
}
