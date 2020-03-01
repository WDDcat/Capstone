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

var companyNameList:[String] = []
var addressList:[String] = []
var legalPersonList:[String] = []
var starList:[String] = ["", "1", "1"]
var cidList:[String] = []

class SearchCompanyController: UITableViewController, UISearchBarDelegate {
    
    var mPresenter = SearchCompanyModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var mData:JSON = []
    private var page = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        searchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        mPresenter.getPerPageInfo(keyword: searchBar.text!, limit:10, page: page)
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
        cell.mPresenter = SearchCompanyModel()
        
        cell.label_companyName.text = companyNameList[indexPath.row]
        cell.label_address.text = "地址：\(addressList[indexPath.row])"
        cell.label_legalPerson.text = "法人：\(legalPersonList[indexPath.row])"
        let image = starList[indexPath.row] == "1" ? "star.fill" : "star"
        cell.btn_star.setImage(UIImage(systemName: image), for: .normal)
        cell.c_id = cidList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (page * 10 + 9){
            print("refresh")
            page = page + 1
            mPresenter.getPerPageInfo(keyword: searchBar.text!, limit:10, page: page)
        }
    }
    
    // MARK: - Table view response set
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        setCompanyId(id: cidList[indexPath.row])
        print("didSelect")
    }
    
    // MARK: - Search Bar set
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
        searchBar.enablesReturnKeyAutomatically = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        page = 0
        companyNameList.removeAll()
        addressList.removeAll()
        legalPersonList.removeAll()
        mPresenter.getPerPageInfo(keyword: searchBar.text!, limit:10, page: page)
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

extension SearchCompanyController: SearchCompanyView {
    func refreshCompanyList() {
        self.tableView.reloadData()
    }
}
