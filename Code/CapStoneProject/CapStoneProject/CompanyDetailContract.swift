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
}

protocol CompanyDetailPresent {
    func getInfo()
}

//protocol CompanyDetailView {
//    func setCompanyName(name: String)   //设置公司名称
//}
