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
    func setEquityFinancingInfo(para: String)
    func setAssetManagementPlanInfo(para: String)
    func setCorporateCreditInfo(para: String)
    func setCorporateBondInfo(para: String)
    func setCorporateEquityFinancingInfo(para: String)
    func setCorporateDebtInfo(para: String)
    func setCorporateAssetManagementPlanInfo(para: String)
    
    func setCreditTable(dataList: [String])
    func setBondTable(dataList: [String])
    func setDebtTable(dataList: [String], latestDate: String)
    func setCashFlowTable(dataList: [String], latestDate: String)
    func setEquityFinancingTable(dataList: [String])
    func setCorporateCreditTable(dataList: [String])
    func setCorporateBondTable(dataList: [String])
    func setCorporateEquityFinancingTable(dataList: [String])
    func setCorporateDebtTable(dataList: [String], latestDate: String)
    func setCorporateCashFlowTable(dataList: [String], latestDate: String)
    
    func setTrustTable(dataList: [String])
    func setInsuranceTable(dataList: [String])
    func setSecurityTable(dataList: [String])
    func setCorporateTrustTable(dataList: [String])
    func setCorporateInsuranceTable(dataList: [String])
    func setCorporateSecurityTable(dataList: [String])
    
    func initTotalPriceChart(valueSize: Int)
    func setTotalPriceChartData(_ yValues1: [ChartDataEntry], _ yValues2: [ChartDataEntry], _ yValues3: [ChartDataEntry], _ yValues4: [ChartDataEntry])
    func initPriceRateChart(valueSize: Int)
    func setPriceRateChartData(_ yValues1: [ChartDataEntry], _ yValues2: [ChartDataEntry], _ yValues3: [ChartDataEntry], _ yValues4: [ChartDataEntry])
    
    func removeView()
}

protocol CapitalRaisingInfoDetailPresent {
    func getInfo()
}
