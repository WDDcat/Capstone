//
//  SearchCompanyContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/28.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol SearchCompanyView {
    func refreshCompanyList()
    func setFooterView(count: Int, total:Int)
}

protocol SearchCompanyPresenter {
    func getPerPageInfo(keyword: String, limit:Int, page: Int)
    func postAddCollect(c_id: String, name: String, recordName: String) ->Bool
    func postCancelCollect(c_id: String, name: String, recordName: String) -> Bool
}
