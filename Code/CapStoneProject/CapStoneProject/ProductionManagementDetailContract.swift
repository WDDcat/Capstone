//
//  ProductionManagementDetailContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/6.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol ProductionManagementDetailView {
    func setBusinessInfo(businessInfo: String)
    func setProductTable()
    func setAreaTable()
}

protocol ProductionManagementDetailPresent {
    func getInfo()
}
