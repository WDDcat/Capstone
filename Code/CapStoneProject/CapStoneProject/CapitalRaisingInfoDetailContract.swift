//
//  CapitalRaisingInfoDetailContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/11.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol CapitalRaisingInfoDetailView {
    func setGroupCapitalRaisingOverviewInfo(para: String)
    func setGroupCreditInfo(para: String)
    func setCreditTable(dataList: [String])
}

protocol CapitalRaisingInfoDetailPresent {
    func getInfo()
}
