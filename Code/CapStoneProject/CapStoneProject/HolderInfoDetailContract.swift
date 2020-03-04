//
//  HolderInfoDetailContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/4.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol HolderInfoDetailView {
    func setHolderName(name: String)
    func setStockCode(codes: [String])
    func setPieChartData()
}

protocol HolderInfoDetailPresent {
    func getInfo()
}
