//
//  SearchCompanyController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD


class SearchCompanyController: UITableViewController {

    private var companyNameList:[String] = []
    private var addressList:[String] = []
    private var legalPersonList:[String] = []
    private var mData:JSON = []
    private var page = 0
    private var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //SVProgressHUD.show()
        self.getData()
    }
    
    func getData(){
        let param:[String:Any] = ["keyword":"海南", "limit": 10, "page": page]          //海南航空：10 海南：2230 A:133
        Alamofire.request(URL(string :"http://47.92.50.218:8881/api1/search_company")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        let result = json["result"]
                        self.count = json["count"].intValue
                        print("\(result.count + (self.page * 10))/\(json["count"])")
                        
                        for i in 0...9 {
                            if i > result.count { break }
                            self.companyNameList.append(result[i][1].string ?? "")
                            self.addressList.append(result[i][4].string ?? "")
                            self.legalPersonList.append(result[i][2].string ?? "")
                        }
                        self.tableView.reloadData()
                    }
                    //SVProgressHUD.dismiss()
                case false:
                    //SVProgressHUD.showError(withStatus: "获取失败")
                    print("fail")
                }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return companyNameList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyItem", for: indexPath) as! CompanyItemCell
        
        cell.label_companyName.text = companyNameList[indexPath.row]
        cell.label_address.text = addressList[indexPath.row]
        cell.label_legalPerson.text = "法人：\(legalPersonList[indexPath.row])"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (page * 10 + 9){
            if ((self.page + 1) * 10) >= self.count { return }
            page = page + 1
            getData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
