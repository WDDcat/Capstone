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
}

protocol SearchCompanyPresenter {
    func getPerPageInfo(keyword: String, limit:Int, page: Int)
}
