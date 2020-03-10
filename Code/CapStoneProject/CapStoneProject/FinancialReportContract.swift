//
//  FinancialReportContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol FinancialReportView {
    func setCompanyName(name: String)
    func setTags(tags:[String])
    func setgroupName(name: String)
    func setLegalPerson(name: String)
    func setShareHolder(company: String, percent: String)
    func setHistory(paragraph: String)
    func setManager(names: String)
    func setBusinessInfo(paragraph: String)
    func setProductList(productList: [[String]])
    func setLocationList(locationList: [[String]])
    func setFinancingInfo(paragraph: String)
    func setRaisingInfo(paragraph: String)
}

protocol FinancialReportPresent {
    func getInfo()
}
