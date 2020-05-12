//
//  CompanyDetailContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol CompanyDetailView {
    func setCompanyName(name: String)
    func setShareHolder(name: String)
    func setLegalPerson(name: String)
    func setStarStatus(status: Int)
    func addSuccess()
    func cancelSuccess()
}

protocol CompanyDetailPresent {
    func getInfo()
    func postAddCollect(name: String)
    func postCancelCollect(name: String)
}

//protocol CompanyDetailView {
//    func setCompanyName(name: String)   //设置公司名称
//}
