//
//  FinancingInfoDetailContract.swift
//  
//
//  Created by Shiyu Wang on 2020/3/9.
//

import Foundation

protocol FinancingInfoDetailView {
    func setTopSummary(para: String)
    func setPreList(para: String)
    func setAttention(para: String)
    func setTable(data: [String])
    func setChartColumn(col: Int)
}

protocol FinancingInfoDetailPresent {
    func getInfo()
}
