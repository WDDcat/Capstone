//
//  CapitalRaisingInfoDetailContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/11.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Charts

protocol CapitalRaisingInfoDetailView {
    func setGroupCapitalRaisingOverviewInfo(para: String)
    func setGroupCreditInfo(para: String)
    func setBondCapitalRaisingInfo(para: String)
    func setDebtInfo(para: String)
    
    func setCreditTable(dataList: [String])
    func setBondTable(dataList: [String])
    func setDebtTable(dataList: [String], latestDate: String)
    func setCashFlowTable(dataList: [String], latestDate: String)
    
    func initTotalPriceChart(valueSize: Int)
    func setTotalPriceChartData(_ yValues1: [ChartDataEntry], _ yValues2: [ChartDataEntry], _ yValues3: [ChartDataEntry], _ yValues4: [ChartDataEntry])
    func initPriceRateChart(valueSize: Int)
    func setPriceRateChartData(_ yValues1: [ChartDataEntry], _ yValues2: [ChartDataEntry], _ yValues3: [ChartDataEntry], _ yValues4: [ChartDataEntry])
}

protocol CapitalRaisingInfoDetailPresent {
    func getInfo()
}
