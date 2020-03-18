//
//  FinancingInfoDetailContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/18.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol FinancingInfoDetailView {
    func setTopSummary(para: String)
    func setPreList(para: String)
    func setAttention(para: String)
    func setChartColumn(col: Int)
    func setTable(data: [String])
}

protocol FinancingInfoDetailPresent {
    func getInfo()
}
