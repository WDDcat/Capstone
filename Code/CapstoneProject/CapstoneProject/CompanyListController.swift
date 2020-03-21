//
//  SearchCompanyController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit

var SearchCompanyNameList:[String] = []
var SearchCompanyAddressList:[String] = []
var SearchCompanyLegalPersonList:[String] = []
var SearchCompanyStarList:[String] = []
var SearchCompanyCidList:[String] = []

class CompanyListController: UITableViewController, UISearchBarDelegate {
    
    var mPresenter = CompanyListModel()
    
    private var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        
        SearchCompanyNameList.removeAll()
        SearchCompanyAddressList.removeAll()
        SearchCompanyLegalPersonList.removeAll()
        SearchCompanyStarList.removeAll()
        SearchCompanyCidList.removeAll()
        mPresenter.getPerPageInfo(keyword: remoteGetSearchKeyword(), limit:10, page: page)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SearchCompanyNameList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "companyItem", for: indexPath) as! CompanyListCell
        cell.mPresenter = CompanyListModel()
        
        cell.label_companyName.text = SearchCompanyNameList[indexPath.row]
        cell.label_address.text = "地址：\(SearchCompanyAddressList[indexPath.row])"
        cell.label_legalPerson.text = "法人：\(SearchCompanyLegalPersonList[indexPath.row])"
        let image = SearchCompanyStarList[indexPath.row] == "1" ? "star.fill" : "star"
        cell.btn_star.setImage(UIImage(systemName: image), for: .normal)
        cell.c_id = SearchCompanyCidList[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (page * 10 + 9){
            print("refresh")
            page = page + 1
            mPresenter.getPerPageInfo(keyword: remoteGetSearchKeyword(), limit:10, page: page)
        }
    }
    
    // MARK: - Table view response set
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        remoteSetCompanyId(id: SearchCompanyCidList[indexPath.row])
        remoteSetCompanyName(name: SearchCompanyNameList[indexPath.row])
        print("didSelect:\(SearchCompanyNameList[indexPath.row])")
    }
}

extension CompanyListController {
//    // MARK: - Search Bar set
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.becomeFirstResponder()
//        searchBar.enablesReturnKeyAutomatically = true
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        page = 0
//        SearchCompanyNameList.removeAll()
//        SearchCompanyAddressList.removeAll()
//        SearchCompanyLegalPersonList.removeAll()
//        SearchCompanyStarList.removeAll()
//        SearchCompanyCidList.removeAll()
//        mPresenter.getPerPageInfo(keyword: searchBar.text!, limit:10, page: page)
//    }
}

extension CompanyListController: CompanyListView {
    func refreshCompanyList() {
        self.tableView.reloadData()
    }
    
    func setFooterView(count: Int, total:Int){
        let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 21)
        view.backgroundColor = .gray
        view.textColor = .white
        if(count == total) {
            view.text = "共\(total)个结果"
        }else {
            view.text = "正在加载..."
        }
        view.textAlignment = .center
        tableView.tableFooterView = view
    }
}
