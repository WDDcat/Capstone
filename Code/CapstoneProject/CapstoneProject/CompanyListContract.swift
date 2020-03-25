//
//  SearchCompanyContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/28.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol CompanyListView {
    func refreshCompanyList()
    func setFooterView(count: Int, total:Int)
}

protocol CompanyListPresenter {
    func getPerPageInfo(keyword: String, limit:Int, page: Int)
}
