//
//  CapitalRaisingInfoDetail.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/9.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Charts

class CapitalRaisingInfoDetailModel: CapitalRaisingInfoDetailPresent {
    
    var mView: CapitalRaisingInfoDetailView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)financing_info_0729")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["error"].int ?? 1) == 0 {
                            if !isNullOrEmpty(json["g_name"].string ?? "") || !isNullOrEmpty(json["g_id"].string ?? "") {
                                self.getGroupInfo(gName: json["g_name"].string ?? "", gId: json["g_id"].string ?? "")
                            }
                            else { //gname和gid都为空
//                                mView.removeView()
//                                mView.setProgressBar(false)
                            }
                            
                            //MARK: -企业信息
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "YYYY年MM月dd日"// 自定义时间格式
                            let creditJSON = json["credit_total"]
                            var currencyList: [Credit] = []
                            for i in 0..<creditJSON.count {
                                if(!isNullOrEmpty(creditJSON[i]["currency"].string ?? "")) {
                                    if (notNull(creditJSON[i]["currency"].string ?? "") == "人民币元" || notNull(creditJSON[i]["currency"].string ?? "") == "人民币") {
                                        currencyList.append(Credit(priority: 1,
                                                                   currency: creditJSON[i]["currency"].string ?? "",
                                                                   used: creditJSON[i]["used"].string ?? "",
                                                                   amount: creditJSON[i]["amount"].string ?? "-",
                                                                   unused: creditJSON[i]["unused"].string ?? ""))
                                    }
                                    else if (notNull(creditJSON[i]["currency"].string ?? "") == "美元") {
                                        currencyList.append(Credit(priority: 2,
                                                                   currency: creditJSON[i]["currency"].string ?? "",
                                                                   used: creditJSON[i]["used"].string ?? "",
                                                                   amount: creditJSON[i]["amount"].string ?? "-",
                                                                   unused: creditJSON[i]["unused"].string ?? ""))
                                    }
                                    else if (notNull(creditJSON[i]["currency"].string ?? "") == "欧元") {
                                        currencyList.append(Credit(priority: 3,
                                                                   currency: creditJSON[i]["currency"].string ?? "",
                                                                   used: creditJSON[i]["used"].string ?? "",
                                                                   amount: creditJSON[i]["amount"].string ?? "-",
                                                                   unused: creditJSON[i]["unused"].string ?? ""))
                                    }
                                    else if (notNull(creditJSON[i]["currency"].string ?? "") == "日元") {
                                        currencyList.append(Credit(priority: 4,
                                                                   currency: creditJSON[i]["currency"].string ?? "",
                                                                   used: creditJSON[i]["used"].string ?? "",
                                                                   amount: creditJSON[i]["amount"].string ?? "-",
                                                                   unused: creditJSON[i]["unused"].string ?? ""))
                                    }
                                    else {
                                        currencyList.append(Credit(priority: 5,
                                                                   currency: creditJSON[i]["currency"].string ?? "",
                                                                   used: creditJSON[i]["used"].string ?? "",
                                                                   amount: creditJSON[i]["amount"].string ?? "-",
                                                                   unused: creditJSON[i]["unused"].string ?? ""))
                                    }
                                }
                            }
//                            NSSortDescriptor(key: <#T##String?#>, ascending: <#T##Bool#>, selector: <#T##Selector?#>)
                            //MARK: -融资情况概览
                            var financingString = ""
                            if creditJSON.count != 0 {
                                financingString = json["name"].string ?? ""
                                for credit:Credit in currencyList {
                                    financingString += "\(credit.getCurrency())总授信\(unitFormat(credit.getAmont()))亿元，"
                                    financingString += "用信\(unitFormat(credit.getUsed()))亿元。"
                                }
                            }
                            
                            //无总授信就不显示
//                            if json["debt"]["last"].count != 0 {
//                                financingString += "根据公开信息显示，该企业合计存量债券\(unitFormat(json["bond_total"]["total"].double ?? 0))亿元，"
//                                financingString += "短期借款\(unitFormat(json["debt"]["last"][1].double ?? 0))元，"
//                                financingString += "长期借款\(unitFormat(json["debt"]["last"][4].double ?? 0))元，"
//                                financingString += "发行股票募集资金\(unitFormat((json["share_financing_total"]["total"].double ?? 0) / 10000))亿元。"
//                            }
                            
                            //MARK: -贷款银行的授信情况
                            var creditString = ""
                            if json["credit_total"].count != 0 {
                                creditString = "截至\(json["credit_total"][0]["time"])日，申请人主要合作银行的"
                                for credit in currencyList {
                                    creditString += "\(credit.getCurrency())授信总额\(unitFormat(credit.getAmont()))亿元，"
                                    creditString += "未使用的授信总额\(unitFormat(credit.getUnused()))亿元。"
                                }
                                creditString += "合作的银行主要情况如下表："
                            }
                            else {
                                creditString = "该公司无公开授信用信"
                            }
                            
                            self.mView?.setCorporateCreditInfo(para: "\(financingString)\n\(creditString)")
                            
                            //MARK: -主要合作情况表格
                            var groupCreditList: [String] = []
                            var currency: [String] = []
                            var total: [[String]] = [] //bank, amount, used, unused, currency, limit_date
                            for i in 0..<json["credit_detail"].count {
                                if isNullOrEmpty(json["credit_detail"][i]["bank"].string ?? "") || isNullOrEmpty(json["credit_detail"][i]["currency"].string ?? "") {
                                    continue
                                }
                                else {
                                    if (json["credit_detail"][i]["bank"].string ?? "") != "合计" {
                                        if currency.count == 0 {
                                            currency.append(json["credit_detail"][i]["currency"].string ?? "")
                                        }
                                        else {
                                            for j in 0..<currency.count {
                                                if currency[j] == (json["credit_detail"][i]["currency"].string ?? "") { break }
                                                else if j == currency.count - 1 {
                                                    currency.append(json["credit_detail"][i]["currency"].string ?? "")
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        var itemTotal: [String] = []
                                        itemTotal.append("小计")
                                        itemTotal.append(unitFormat(json["credit_detail"][i]["amount"].string ?? "0"))
                                        itemTotal.append(unitFormat(json["credit_detail"][i]["used"].string ?? "0"))
                                        itemTotal.append(unitFormat(json["credit_detail"][i]["unused"].string ?? "0"))
                                        itemTotal.append(json["credit_detail"][i]["currency"].string ?? "")
                                        itemTotal.append(json["credit_detail"][i]["limit_date"].string ?? "")
                                        total.append(itemTotal)
                                    }
                                }
                            }
                            for i in 0..<currency.count {
                                for j in 0..<json["credit_detail"].count {
                                    if (json["credit_detail"][j]["bank"].string ?? "") != "合计" && (json["credit_detail"][j]["currency"].string ?? "") == currency[i] {
                                        groupCreditList.append(json["credit_detail"][j]["bank"].string ?? "")
                                        groupCreditList.append(unitFormat(json["credit_detail"][j]["amount"].string ?? "0"))
                                        groupCreditList.append(unitFormat(json["credit_detail"][j]["used"].string ?? "0"))
                                        groupCreditList.append(unitFormat(json["credit_detail"][j]["unused"].string ?? "0"))
                                        groupCreditList.append(json["credit_detail"][j]["currency"].string ?? "")
                                        groupCreditList.append(json["credit_detail"][j]["limit_date"].string ?? "")
                                    }
                                }
                                for j in 0..<total.count {
                                    if total[j][4] == currency[i] {
                                        groupCreditList.append(total[j][0])
                                        groupCreditList.append(total[j][1])
                                        groupCreditList.append(total[j][2])
                                        groupCreditList.append(total[j][3])
                                        groupCreditList.append(total[j][4])
                                        groupCreditList.append(total[j][5])
                                    }
                                }
                            }
                            if currency.count == 0 && total.count != 0 { //只有合计的情况
                                for i in 0..<total.count {
                                    groupCreditList.append(total[i][0])
                                    groupCreditList.append(total[i][1])
                                    groupCreditList.append(total[i][2])
                                    groupCreditList.append(total[i][3])
                                    groupCreditList.append(total[i][4])
                                    groupCreditList.append(total[i][5])
                                }
                            }
                            self.mView?.setCorporateCreditTable(dataList: groupCreditList)
                            
                            //MARK: -债券融资情况
                            var bondString = ""
                            if (json["rating"]["organ"].string ?? "") != "" {
                                bondString = "经\(json["rating"]["organ"])评定，申请人的\(((json["rating"]["date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年主体信用等级为\(json["rating"]["rating"].string ?? "-")。较上年主体信用评级\(json["rating"]["move"])。"
                            }
                            if (json["bond_total"]["total"].string ?? "") != "" {
                                bondString += "\n截至\(dateformatter.string(from: Date()))，该企业尚处于存续期内债券合计\(unitFormat(json["bond_total"]["total"].string ?? "-"))亿元，"
                                bondString += "平均期限\(unitFormat(json["bond_total"]["avg_deadline"].int ?? 0))月，"
                                bondString += "平均票面利率\(json["bond_total"]["avg_inter_rate"].string ?? "-")%。集团及其子公司处在存续期内的"
                                if json["bond_total"]["classify"].count != 0 {
                                    for i in 0..<json["bond_total"]["classify"].count {
                                        if (json["bond_total"]["classify"][i]["classify"].string ?? "") != "" {
                                            if i < (json["bond_total"]["classify"].count - 1) {
                                                bondString += "\(json["bond_total"]["classify"][i]["classify"].string ?? "")\(String(json["bond_total"]["classify"][i]["count"].int ?? 0))只，金额共\(unitFormat(json["bond_total"]["classify"][i]["total"].string ?? "-"))亿元；"
                                            }
                                            else {
                                                bondString += "\(json["bond_total"]["classify"][i]["classify"].string ?? "")\(String(json["bond_total"]["classify"][i]["count"].int ?? 0))只，金额共\(unitFormat(json["bond_total"]["classify"][i]["total"].string ?? "-"))亿元。具体情况如下表："
                                            }
                                        }
                                     }
                                }
                                self.mView?.setCorporateBondInfo(para: bondString)
                                
                                //MARK: -债券表格
                                var bondList: [String] = []
                                if json["bond_detail"].count != 0 {
                                    for i in 0..<json["bond_detail"].count {
                                        bondList.append(json["bond_detail"][i]["debt_subject"].string ?? "")
                                        bondList.append(json["bond_detail"][i]["list_date"].string ?? "")
                                        bondList.append(unitFormat(json["bond_detail"][i]["deadline"].int ?? 0))
                                        bondList.append(unitFormat(json["bond_detail"][i]["total"].string ?? ""))
                                        bondList.append(json["bond_detail"][i]["lead_underwriter"].string ?? "")
                                        bondList.append(json["bond_detail"][i]["classify"].string ?? "")
                                    }
                                }
                                for i in 0..<json["bond_total"]["classify"].count {
                                    bondList.append("小计")
                                    bondList.append("-")
                                    bondList.append("-")
                                    bondList.append(unitFormat(json["bond_total"]["classify"][i]["total"].string ?? "-"))
                                    bondList.append("-")
                                    bondList.append(json["bond_total"]["classify"][i]["classify"].string ?? "-")
                                }
                                bondList.append("合计")
                                bondList.append("-")
                                bondList.append(unitFormat(json["bond_total"]["avg_deadline"].int ?? 0))
                                bondList.append(unitFormat(json["bond_total"]["total"].string ?? "-"))
                                bondList.append("-")
                                bondList.append("-")
                                self.mView?.setCorporateBondTable(dataList: bondList)
                            }
                            else {
                                bondString = "本公司暂无公开债券信息"
                                self.mView?.setCorporateBondInfo(para: bondString)
                            }
                            
                            //MARK: -股权融资情况
                            var sharingFinancingString = ""
                            if (json["share_financing_total"]["total"].double ?? 0) != 0 {
                                sharingFinancingString = "根据公开信息显示，企业合计通过股票市场融资\(unitFormat((json["share_financing_total"]["total"].double ?? 0) / 10000))亿元。"
                                sharingFinancingString += "股票募集资金情况如下表："
                                self.mView?.setEquityFinancingInfo(para: sharingFinancingString)
                                
                                //MARK: -股权融资表格
                                var sharingFinancingList: [String] = []
                                for i in 0..<json["share_financing_detail"].count {
                                    for j in 0..<json["share_financing_detail"][i]["detail"].count {
                                        sharingFinancingList.append(json["share_financing_detail"][i]["s_name"].string ?? "-")
                                        sharingFinancingList.append(json["share_financing_detail"][i]["detail"][j][1].string ?? "-")
                                        sharingFinancingList.append(json["share_financing_detail"][i]["detail"][j][0].string ?? "-")
                                        sharingFinancingList.append(json["share_financing_detail"][i]["address"].string ?? "-")
                                        sharingFinancingList.append(unitFormat(json["share_financing_detail"][i]["detail"][j][2].double ?? 0))
                                        sharingFinancingList.append(unitFormat(json["share_financing_detail"][i]["detail"][j][3].double ?? 0))
                                        sharingFinancingList.append(unitFormat((json["share_financing_detail"][i]["detail"][j][4].double ?? 0) / 10000))
                                        sharingFinancingList.append(json["share_financing_detail"][i]["lead_underwriter"].string ?? "-")
                                    }
                                }
                                self.mView?.setCorporateEquityFinancingTable(dataList: sharingFinancingList)
                            }
                            else {
                                sharingFinancingString = "该公司暂无公开股票融资信息"
                                self.mView?.setCorporateEquityFinancingInfo(para: sharingFinancingString)
                            }
                            
                            //MARK: -有息负债情况
                            var debtString = ""
                            if (json["debt"]["total"].double ?? 0) != 0 {
                                debtString = "根据公开数据显示，在\(((json["debt"]["last"][0].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年，"
                                debtString += "该企业有息负债共\(unitFormat(json["debt"]["total"].double ?? 0))元。"
                            }
                            else {
                                debtString = "该集团无公开有息债券信息。"
                            }
                            if json["debt"]["three_years"].count != 0 {
                                debtString += "近三年及最近一期有息债务具体情况如下表："
                            }
                            self.mView?.setCorporateDebtInfo(para: debtString)
                            
                            //MARK: -有息债券表格
                            var debtList: [String] = []
                            var latest = ""
                            let debtTitleList = ["短期借款", "应付票据", "一年内到期的非流动负债", "长期借款", "应付债款", "应付租赁款", "合计"]
                            if json["debt"]["three_years"].count != 0 {
                                for i in 0..<7 {
                                    for j in 0..<2 {
                                        if j == 0 {
                                            debtList.append(debtTitleList[i])
                                        }
                                        else {
                                            let size = json["debt"]["three_years"].count
                                            for k in (0..<size).reversed() {
                                                if i == 6 {
                                                    debtList.append(unitFormat(json["debt"]["three_years"][k][20].double ?? 0))
                                                    debtList.append(json["debt"]["three_years"][k][21].string ?? "-")
                                                }
                                                else {
                                                    debtList.append(unitFormat(json["debt"]["three_years"][k][i + 1].double ?? 0))
                                                    debtList.append(json["debt"]["three_years"][k][i + 14].string ?? "-")
                                                }
                                            }
                                            if size == 1 {
                                                debtList.append("-")
                                                debtList.append("-")
                                                debtList.append("-")
                                                debtList.append("-")
                                            }
                                            else if size == 2 {
                                                debtList.append("-")
                                                debtList.append("-")
                                            }
                                            
                                            if json["debt"]["last"].count == 0 {
                                                debtList.append("-")
                                                debtList.append("-")
                                            }
                                            else {
                                                if i == 6 {
                                                    debtList.append(unitFormat(json["debt"]["last"][19].double ?? 0))
                                                    debtList.append(json["debt"]["last"][20].string ?? "-")
                                                }
                                                else {
                                                    debtList.append(unitFormat(json["debt"]["last"][i + 1].double ?? 0))
                                                    debtList.append(json["debt"]["last"][i + 13].string ?? "-")
                                                }
                                                latest = json["debt"]["last"][0].string ?? "-"
                                            }
                                        }
                                    }
                                }
                            }
                            self.mView?.setCorporateDebtTable(dataList: debtList, latestDate: latest)
                            
                            //MARK: -现金流表格
                            var cashList: [String] = []
                            let cashTitleList = ["取得借款收到的现金", "发行债券收到的现金", "偿还债务支付的现金", "分配股利支付的现金", "净额"]
                            if json["debt"]["three_years"].count != 0 {
                                for i in 0..<5 {
                                    for j in 0..<2 {
                                        if j == 0 {
                                            cashList.append(cashTitleList[i])
                                        }
                                        else {
                                            let size = json["debt"]["three_years"].count
                                            for k in (0..<size).reversed() {
                                                cashList.append(unitFormat(json["debt"]["three_years"][k][i + 8].double ?? 0).replacingOccurrences(of: "亿", with: ""))
                                            }
                                            if size == 1 {
                                                cashList.append("-")
                                                cashList.append("-")
                                            }
                                            else if size == 2 {
                                                cashList.append("-")
                                            }
                                            
                                            if json["debt"]["last"].count == 0 {
                                                cashList.append("-")
                                            }
                                            else {
                                                cashList.append(unitFormat(json["debt"]["last"][i + 8].double ?? 0).replacingOccurrences(of: "亿", with: ""))
                                            }
                                        }
                                    }
                                }
                            }
                            self.mView?.setCorporateCashFlowTable(dataList: cashList, latestDate: latest)
                            
                            //MARK: -资产管理计划情况
                            var planString = ""
                            let trustCount = json["trust"]["count"].int ?? 0
                            let assetCount = json["asset"]["count"].int ?? 0
                            let insuranceCount = json["insurance"]["count"].int ?? 0
                            let planCount = trustCount + assetCount + insuranceCount
                            if planCount == 0 {
                                planString = "该公司暂无公开资产管理计划"
                            }
                            else {
                                planString = "截至\(dateformatter.string(from: Date()))，根据公开数据及相关大数据显示，\(json["name"])作为最终融资方共发行资产管理计划\(planCount)支，"
                                planString += "涉及金额\(json["trust"]["total"].string ?? "-")元，"
                                planString += "其中信托资管计划\(trustCount)支；保险资管计划\(insuranceCount)支；证券资管计划\(assetCount)支。具体如下表："
                            }
                            self.mView?.setCorporateAssetManagementPlanInfo(para: planString)
                            
                            //MARK: -信托表
                            var trustList: [String] = []
                            for i in 0..<json["trust"]["detail"].count {
                                trustList.append(json["trust"]["detail"][i]["comp_name"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["company_name"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["t_name"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["estab_dt"].string ?? "")
                                trustList.append(trustScale(json["trust"]["detail"][i]["t_scale"].string ?? ""))
                                trustList.append(json["trust"]["detail"][i]["t_deadline"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["appli_way"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["in_distr"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["trustee"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["custodian"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["bank"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["t_manag"].string ?? "")
                                trustList.append(json["trust"]["detail"][i]["f_used"].string ?? "")
                            }
                            self.mView?.setCorporateTrustTable(dataList: trustList)
                            
                            //MARK: -保险表
                            var insuranceList: [String] = []
                            for i in 0..<json["insurance"]["detail"].count {
                                insuranceList.append(json["insurance"]["detail"][i]["comp_name"].string ?? "")
                                insuranceList.append(json["insurance"]["detail"][i]["insur_ass_name"].string ?? "")
                                insuranceList.append(json["insurance"]["detail"][i]["reg_number"].string ?? "")
                                insuranceList.append(json["insurance"]["detail"][i]["ann_date"].string ?? "")
                            }
                            self.mView?.setCorporateInsuranceTable(dataList: insuranceList)
                            
                            //MARK: -证券表
                            var securityList: [String] = []
                            for i in 0..<json["asset"]["detail"].count {
                                securityList.append(json["asset"]["detail"][i]["company_name"].string ?? "")
                                securityList.append(json["asset"]["detail"][i]["prod_name"].string ?? "")
                                securityList.append(json["asset"]["detail"][i]["man_name"].string ?? "")
                                securityList.append(json["asset"]["detail"][i]["coll_name"].string ?? "")
                            }
                            self.mView?.setCorporateSecurityTable(dataList: securityList)
                        }
                        else if (json["error"].int ?? 1) == 400 {
//                            mView.accessDenied()
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    //MARK: -集团信息
    func getGroupInfo(gName: String, gId: String) {
        let param:[String:Any] = ["g_id": gId, "g_name": gName]
        print("group: \(gName)with id:\(gId)")
        Alamofire.request(URL(string :"\(BASEURL)financing_group_info_0729")!, parameters: param, headers: header)
                    .responseJSON { response in
                        switch response.result.isSuccess{
                        case true:
                            if let data = response.result.value {
                                let json = JSON(data)
                                if (json["error"].int ?? 1) == 0 {
                                    let dateformatter = DateFormatter()
                                    dateformatter.dateFormat = "YYYY年MM月dd日"// 自定义时间格式
                                    let creditJSON = json["credit_total"]
                                    var currencyList: [Credit] = []
                                    for i in 0..<creditJSON.count {
                                        if(!isNullOrEmpty(creditJSON[i]["currency"].string ?? "")) {
                                            if (notNull(creditJSON[i]["currency"].string ?? "") == "人民币元" || notNull(creditJSON[i]["currency"].string ?? "") == "人民币") {
                                                currencyList.append(Credit(priority: 1,
                                                                           currency: creditJSON[i]["currency"].string ?? "",
                                                                           used: creditJSON[i]["used"].string ?? "",
                                                                           amount: creditJSON[i]["amount"].string ?? "-",
                                                                           unused: creditJSON[i]["unused"].string ?? ""))
                                            }
                                            else if (notNull(creditJSON[i]["currency"].string ?? "") == "美元") {
                                                currencyList.append(Credit(priority: 2,
                                                                           currency: creditJSON[i]["currency"].string ?? "",
                                                                           used: creditJSON[i]["used"].string ?? "",
                                                                           amount: creditJSON[i]["amount"].string ?? "-",
                                                                           unused: creditJSON[i]["unused"].string ?? ""))
                                            }
                                            else if (notNull(creditJSON[i]["currency"].string ?? "") == "欧元") {
                                                currencyList.append(Credit(priority: 3,
                                                                           currency: creditJSON[i]["currency"].string ?? "",
                                                                           used: creditJSON[i]["used"].string ?? "",
                                                                           amount: creditJSON[i]["amount"].string ?? "-",
                                                                           unused: creditJSON[i]["unused"].string ?? ""))
                                            }
                                            else if (notNull(creditJSON[i]["currency"].string ?? "") == "日元") {
                                                currencyList.append(Credit(priority: 4,
                                                                           currency: creditJSON[i]["currency"].string ?? "",
                                                                           used: creditJSON[i]["used"].string ?? "",
                                                                           amount: creditJSON[i]["amount"].string ?? "-",
                                                                           unused: creditJSON[i]["unused"].string ?? ""))
                                            }
                                            else {
                                                currencyList.append(Credit(priority: 5,
                                                                           currency: creditJSON[i]["currency"].string ?? "",
                                                                           used: creditJSON[i]["used"].string ?? "",
                                                                           amount: creditJSON[i]["amount"].string ?? "-",
                                                                           unused: creditJSON[i]["unused"].string ?? ""))
                                            }
                                        }
                                    }
//                                    NSSortDescriptor(key: <#T##String?#>, ascending: <#T##Bool#>, selector: <#T##Selector?#>)
                                    //MARK: -融资情况概览
                                    var financingString = ""
                                    if creditJSON.count != 0 {
                                        financingString = json["group_name"].string ?? ""
                                        for credit:Credit in currencyList {
                                            financingString += "\(credit.getCurrency())总授信\(unitFormat(credit.getAmont()))亿元，"
                                            financingString += "未使用的授信额度为\(unitFormat(credit.getUnused()))亿元；"
                                        }
                                    }
                                    //无总授信就不显示
                                    if json["debt"]["last"].count != 0 {
                                        financingString += "根据公开信息显示，\(json["group_name"].string ?? "")及其下属公司合计存量债券\(unitFormat(json["bond_total"]["total"].double ?? 0))亿元，"
                                        financingString += "短期借款\(unitFormat(json["debt"]["last"][1].double ?? 0))元，"
                                        financingString += "长期借款\(unitFormat(json["debt"]["last"][4].double ?? 0))元，"
                                        financingString += "发行股票募集资金\(unitFormat((json["share_financing_total"]["total"].double ?? 0) / 10000))亿元。"
                                    }
                                    
                                    var bankList: [String] = []
                                    for i in 0..<json["credit_detail"].count {
                                        if i == 10 { break }
                                        if (json["credit_detail"][i]["bank"].string ?? "") != "合计" {
                                            bankList.append(json["credit_detail"][i]["bank"].string ?? "")
                                        }
                                    }
                                    if bankList.count != 0 {
                                        financingString += "该集团合作的前10名金融机构为："
                                        for i in 0..<bankList.count {
                                            if i < (bankList.count - 1) {
                                                financingString += "\(bankList[i])、"
                                            }
                                            else {
                                                financingString += "\(bankList[i])。"
                                            }
                                        }
                                    }
                                    self.mView?.setGroupCapitalRaisingOverviewInfo(para: financingString)
                                    
                                    //MARK: -贷款银行的授信情况
                                    var creditString = ""
                                    if json["credit_total"].count != 0 {
                                        creditString = "截至\(json["credit_total"][0]["time"])日，\(json["group_name"])主要合作银行的"
                                        for credit in currencyList {
                                            creditString += "\(credit.getCurrency())授信总额\(unitFormat(credit.getAmont()))亿元，"
                                        }
                                        creditString += "合作的银行主要情况如下："
                                    }
                                    self.mView?.setGroupCreditInfo(para: creditString)
                                    
                                    //MARK: -主要合作情况表格
                                    var groupCreditList: [String] = []
                                    var currency: [String] = []
                                    var total: [[String]] = [] //bank, amount, used, unused, currency, limit_date
                                    for i in 0..<json["credit_detail"].count {
                                        if isNullOrEmpty(json["credit_detail"][i]["bank"].string ?? "") || isNullOrEmpty(json["credit_detail"][i]["currency"].string ?? "") {
                                            continue
                                        }
                                        else {
                                            if (json["credit_detail"][i]["bank"].string ?? "") != "合计" {
                                                if currency.count == 0 {
                                                    currency.append(json["credit_detail"][i]["currency"].string ?? "")
                                                }
                                                else {
                                                    for j in 0..<currency.count {
                                                        if currency[j] == (json["credit_detail"][i]["currency"].string ?? "") { break }
                                                        else if j == currency.count - 1 {
                                                            currency.append(json["credit_detail"][i]["currency"].string ?? "")
                                                        }
                                                    }
                                                }
                                            }
                                            else {
                                                var itemTotal: [String] = []
                                                itemTotal.append("小计")
                                                itemTotal.append(unitFormat(json["credit_detail"][i]["amount"].string ?? "0"))
                                                itemTotal.append(unitFormat(json["credit_detail"][i]["used"].string ?? "0"))
                                                itemTotal.append(unitFormat(json["credit_detail"][i]["unused"].string ?? "0"))
                                                itemTotal.append(json["credit_detail"][i]["currency"].string ?? "")
                                                itemTotal.append(json["credit_detail"][i]["limit_date"].string ?? "")
                                                total.append(itemTotal)
                                            }
                                        }
                                    }
                                    for i in 0..<currency.count {
                                        for j in 0..<json["credit_detail"].count {
                                            if (json["credit_detail"][j]["bank"].string ?? "") != "合计" && (json["credit_detail"][j]["currency"].string ?? "") == currency[i] {
                                                groupCreditList.append(json["credit_detail"][j]["bank"].string ?? "")
                                                groupCreditList.append(unitFormat(json["credit_detail"][j]["amount"].string ?? "0"))
                                                groupCreditList.append(unitFormat(json["credit_detail"][j]["used"].string ?? "0"))
                                                groupCreditList.append(unitFormat(json["credit_detail"][j]["unused"].string ?? "0"))
                                                groupCreditList.append(json["credit_detail"][j]["currency"].string ?? "")
                                                groupCreditList.append(json["credit_detail"][j]["limit_date"].string ?? "")
                                            }
                                        }
                                        for j in 0..<total.count {
                                            if total[j][4] == currency[i] {
                                                groupCreditList.append(total[j][0])
                                                groupCreditList.append(total[j][1])
                                                groupCreditList.append(total[j][2])
                                                groupCreditList.append(total[j][3])
                                                groupCreditList.append(total[j][4])
                                                groupCreditList.append(total[j][5])
                                            }
                                        }
                                    }
                                    if currency.count == 0 && total.count != 0 { //只有合计的情况
                                        for i in 0..<total.count {
                                            groupCreditList.append(total[i][0])
                                            groupCreditList.append(total[i][1])
                                            groupCreditList.append(total[i][2])
                                            groupCreditList.append(total[i][3])
                                            groupCreditList.append(total[i][4])
                                            groupCreditList.append(total[i][5])
                                        }
                                    }
                                    self.mView?.setCreditTable(dataList: groupCreditList)
                                    
                                    //MARK: -债券融资情况
                                    var bondString = ""
                                    if (json["rating"]["organ"].string ?? "") != "" {
                                        bondString = "经\(json["rating"]["organ"])评定，申请人的\(((json["rating"]["date"].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年主体信用等级为\(json["rating"]["rating"].string ?? "-")。较上年主体信用评级\(json["rating"]["move"])。"
                                    }
                                    if (json["bond_total"]["total"].double ?? -1) != -1 {
                                        bondString += "\n截至\(dateformatter.string(from: Date()))，集团及其子公司尚处于存续期债券合计为\(unitFormat(json["bond_total"]["total"].double ?? 0))亿元，"
                                        bondString += "平均期限\(unitFormat(json["bond_total"]["avg_deadline"].int ?? 0))月，"
                                        bondString += "平均票面利率\(json["bond_total"]["avg_inter_rate"].string ?? "-")%。集团及其子公司处在存续期内的"
                                        if json["bond_total"]["classify"].count != 0 {
                                            for i in 0..<json["bond_total"]["classify"].count {
                                                if (json["bond_total"]["classify"][i]["classify"].string ?? "") != "" {
                                                    if i < (json["bond_total"]["classify"].count - 1) {
                                                        bondString += "\(json["bond_total"]["classify"][i]["classify"].string ?? "")\(String(json["bond_total"]["classify"][i]["count"].int ?? 0))只，金额共\(unitFormat(json["bond_total"]["classify"][i]["total"].int ?? 0))亿元；"
                                                    }
                                                    else {
                                                        bondString += "\(json["bond_total"]["classify"][i]["classify"].string ?? "")\(String(json["bond_total"]["classify"][i]["count"].int ?? 0))只，金额共\(unitFormat(json["bond_total"]["classify"][i]["total"].int ?? 0))亿元。具体情况如下表："
                                                    }
                                                }
                                             }
                                        }
                                        self.mView?.setBondCapitalRaisingInfo(para: bondString)
                                        
                                        //MARK: -债券表格
                                        var bondList: [String] = []
                                        if json["bond_detail"].count != 0 {
                                            for i in 0..<json["bond_detail"].count {
                                                bondList.append(json["bond_detail"][i]["debt_subject"].string ?? "")
                                                bondList.append(json["bond_detail"][i]["list_date"].string ?? "")
                                                bondList.append(unitFormat(json["bond_detail"][i]["deadline"].int ?? 0))
                                                bondList.append(unitFormat(json["bond_detail"][i]["total"].string ?? ""))
                                                bondList.append(json["bond_detail"][i]["lead_underwriter"].string ?? "")
                                                bondList.append(json["bond_detail"][i]["classify"].string ?? "")
                                            }
                                        }
                                        for i in 0..<json["bond_total"]["classify"].count {
                                            bondList.append("小计")
                                            bondList.append("-")
                                            bondList.append("-")
                                            bondList.append(unitFormat(json["bond_total"]["classify"][i]["total"].int ?? 0))
                                            bondList.append("-")
                                            bondList.append(json["bond_total"]["classify"][i]["classify"].string ?? "")
                                        }
                                        bondList.append("合计")
                                        bondList.append("-")
                                        bondList.append(unitFormat(json["bond_total"]["avg_deadline"].int ?? 0))
                                        bondList.append(unitFormat(json["bond_total"]["total"].double ?? 0))
                                        bondList.append("-")
                                        bondList.append("-")
                                        self.mView?.setBondTable(dataList: bondList)
                                    }
                                    else {
                                        bondString = "本公司暂无公开债券信息"
                                        self.mView?.setBondCapitalRaisingInfo(para: bondString)
                                    }
                                    
                                    //MARK: -折线图
                                    var total_1: [Double] = []
                                    var total_2: [Double] = []
                                    var total_3: [Double] = []
                                    var total_4: [Double] = []
                                    var price_1: [Double] = []
                                    var price_2: [Double] = []
                                    var price_3: [Double] = []
                                    var price_4: [Double] = []
                                    var minYear = 9999
                                    var maxYear = 0
                                    for i in 0..<json["bond_detail"].count {
                                        if (json["bond_detail"][i]["list_date"].string ?? "") != "" {
                                            let year = Int(((json["bond_detail"][i]["list_date"].string ?? "") as NSString).substring(to: 4))
                                            if maxYear < year! { maxYear = year! }
                                            if minYear > year! { minYear = year! }
                                        }
                                    }
                                    for i in minYear...maxYear {
                                        var num_1: Int = 0, num_2: Int = 0, num_3: Int = 0, num_4: Int = 0
                                        var total_year1: Double = 0.0, total_year2: Double = 0.0, total_year3: Double = 0.0, total_year4: Double = 0.0
                                        var price_year1: Double = 0.0, price_year2: Double = 0.0, price_year3: Double = 0.0, price_year4: Double = 0.0
                                        for j in 0..<json["bond_detail"].count {
                                            if (json["bond_detail"][j]["list_date"].string ?? "") != "" && (json["bond_detail"][j]["deadline"].int ?? 0) != 0 {
                                                let year = Int(((json["bond_detail"][j]["list_date"].string ?? "") as NSString).substring(to: 4))
                                                if year == i && (json["bond_detail"][j]["inter_rate"].string ?? "") != "" {
                                                    let deadline = Double(json["bond_detail"][j]["deadline"].double ?? 0)
                                                    if (deadline / 12) <= 1 {
                                                        total_year1 += Double(json["bond_detail"][j]["total"].string ?? "0")!
                                                        price_year1 += Double(json["bond_detail"][j]["inter_rate"].string ?? "0")!
                                                        num_1 += 1
                                                    }
                                                    else if (deadline / 12) <= 3 {
                                                        total_year2 += Double(json["bond_detail"][j]["total"].string ?? "0")!
                                                        price_year2 += Double(json["bond_detail"][j]["inter_rate"].string ?? "0")!
                                                        num_2 += 1
                                                    }
                                                    else if (deadline / 12) <= 5 {
                                                        total_year3 += Double(json["bond_detail"][j]["total"].string ?? "0")!
                                                        price_year3 += Double(json["bond_detail"][j]["inter_rate"].string ?? "0")!
                                                        num_3 += 1
                                                    }
                                                    else {
                                                        total_year4 += Double(json["bond_detail"][j]["total"].string ?? "0")!
                                                        price_year4 += Double(json["bond_detail"][j]["inter_rate"].string ?? "0")!
                                                        num_4 += 1
                                                    }
                                                }
                                            }
                                        }
                                        if num_1 == 0 {
                                            total_1.append(0)
                                            price_1.append(0)
                                        }
                                        else {
                                            total_1.append(total_year1 / Double(num_1))
                                            price_1.append(price_year1 / Double(num_1))
                                        }
                                        if num_2 == 0 {
                                            total_2.append(0)
                                            price_2.append(0)
                                        }
                                        else {
                                            total_2.append(total_year2 / Double(num_2))
                                            price_2.append(price_year2 / Double(num_2))
                                        }
                                        if num_3 == 0 {
                                            total_3.append(0)
                                            price_3.append(0)
                                        }
                                        else {
                                            total_3.append(total_year3 / Double(num_3))
                                            price_3.append(price_year3 / Double(num_3))
                                        }
                                        if num_4 == 0 {
                                            total_4.append(0)
                                            price_4.append(0)
                                        }
                                        else {
                                            total_4.append(total_year4 / Double(num_4))
                                            price_4.append(price_year4 / Double(num_4))
                                        }
                                        
                                        var xValues: [String] = []
                                        for _ in 0..<5 {
                                            xValues.append("\(i):00")
                                        }
                                        
                                        //MARK: -表1
                                        var yValues1: [ChartDataEntry] = []
                                        var yValues2: [ChartDataEntry] = []
                                        var yValues3: [ChartDataEntry] = []
                                        var yValues4: [ChartDataEntry] = []
                                        for i in 0..<total_1.count {
                                            yValues1.append(ChartDataEntry.init(x: Double(minYear + i), y: total_1[i]))
                                        }
                                        for i in 0..<total_2.count {
                                            yValues2.append(ChartDataEntry.init(x: Double(minYear + i), y: total_2[i]))
                                        }
                                        for i in 0..<total_3.count {
                                            yValues3.append(ChartDataEntry.init(x: Double(minYear + i), y: total_3[i]))
                                        }
                                        for i in 0..<total_4.count {
                                            yValues4.append(ChartDataEntry.init(x: Double(minYear + i), y: total_4[i]))
                                        }
                                        
                                        if yValues1.count == 0 { yValues1.append(ChartDataEntry.init(x: 2015, y: 0)) }
                                        if yValues2.count == 0 { yValues2.append(ChartDataEntry.init(x: 2015, y: 0)) }
                                        if yValues3.count == 0 { yValues3.append(ChartDataEntry.init(x: 2015, y: 0)) }
                                        if yValues4.count == 0 { yValues4.append(ChartDataEntry.init(x: 2015, y: 0)) }
                                        
                                        self.mView?.initTotalPriceChart(valueSize: max(yValues1.count, yValues2.count, yValues3.count, yValues4.count))
                                        self.mView?.setTotalPriceChartData(yValues1, yValues2, yValues3, yValues4)
                                        //MARK: -表2
                                        yValues1.removeAll()
                                        yValues2.removeAll()
                                        yValues3.removeAll()
                                        yValues4.removeAll()
                                        
                                        for i in 0..<total_1.count {
                                            yValues1.append(ChartDataEntry.init(x: Double(minYear + i), y: price_1[i]))
                                        }
                                        for i in 0..<total_2.count {
                                            yValues2.append(ChartDataEntry.init(x: Double(minYear + i), y: price_2[i]))
                                        }
                                        for i in 0..<total_3.count {
                                            yValues3.append(ChartDataEntry.init(x: Double(minYear + i), y: price_3[i]))
                                        }
                                        for i in 0..<total_4.count {
                                            yValues4.append(ChartDataEntry.init(x: Double(minYear + i), y: price_4[i]))
                                        }
                                        
                                        if yValues1.count == 0 { yValues1.append(ChartDataEntry.init(x: 2015, y: 0)) }
                                        if yValues2.count == 0 { yValues2.append(ChartDataEntry.init(x: 2015, y: 0)) }
                                        if yValues3.count == 0 { yValues3.append(ChartDataEntry.init(x: 2015, y: 0)) }
                                        if yValues4.count == 0 { yValues4.append(ChartDataEntry.init(x: 2015, y: 0)) }
                                        
                                        self.mView?.initPriceRateChart(valueSize: max(yValues1.count, yValues2.count, yValues3.count, yValues4.count))
                                        self.mView?.setPriceRateChartData(yValues1, yValues2, yValues3, yValues4)
                                    }
                                    
                                    
                                    //MARK: -有息负债情况
                                    var debtString = ""
                                    if (json["debt"]["total"].double ?? 0) != 0 {
                                        debtString = "根据公开信息显示，在\(((json["debt"]["last"][0].string ?? "    ") as NSString).substring(to: 4).replacingOccurrences(of: "    ", with: "-"))年，"
                                        debtString += "该集团有息负债共\(unitFormat(json["debt"]["total"].double ?? 0))元。"
                                    }
                                    else {
                                        debtString = "该集团无公开有息债券信息。"
                                    }
                                    if json["debt"]["three_years"].count != 0 {
                                        debtString += "近三年及最近一期有息债务具体情况如下表："
                                    }
                                    self.mView?.setDebtInfo(para: debtString)
                                    
                                    //MARK: -有息债券表格
                                    var debtList: [String] = []
                                    var latest = ""
                                    let debtTitleList = ["短期借款", "应付票据", "一年内到期的非流动负债", "长期借款", "应付债款", "应付租赁款", "合计"]
                                    if json["debt"]["three_years"].count != 0 {
                                        for i in 0..<7 {
                                            for j in 0..<2 {
                                                if j == 0 {
                                                    debtList.append(debtTitleList[i])
                                                }
                                                else {
                                                    let size = json["debt"]["three_years"].count
                                                    for k in (0..<size).reversed() {
                                                        if i == 6 {
                                                            debtList.append(unitFormat(json["debt"]["three_years"][k][20].double ?? 0))
                                                            debtList.append(json["debt"]["three_years"][k][21].string ?? "-")
                                                        }
                                                        else {
                                                            debtList.append(unitFormat(json["debt"]["three_years"][k][i + 1].double ?? 0))
                                                            debtList.append(json["debt"]["three_years"][k][i + 14].string ?? "-")
                                                        }
                                                    }
                                                    if size == 1 {
                                                        debtList.append("-")
                                                        debtList.append("-")
                                                        debtList.append("-")
                                                        debtList.append("-")
                                                    }
                                                    else if size == 2 {
                                                        debtList.append("-")
                                                        debtList.append("-")
                                                    }
                                                    
                                                    if json["debt"]["last"].count == 0 {
                                                        debtList.append("-")
                                                        debtList.append("-")
                                                    }
                                                    else {
                                                        if i == 6 {
                                                            debtList.append(unitFormat(json["debt"]["last"][19].double ?? 0))
                                                            debtList.append(json["debt"]["last"][20].string ?? "-")
                                                        }
                                                        else {
                                                            debtList.append(unitFormat(json["debt"]["last"][i + 1].double ?? 0))
                                                            debtList.append(json["debt"]["last"][i + 13].string ?? "-")
                                                        }
                                                        latest = json["debt"]["last"][0].string ?? "-"
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.mView?.setDebtTable(dataList: debtList, latestDate: latest)
                                    
                                    //MARK: -现金流表格
                                    var cashList: [String] = []
                                    let cashTitleList = ["取得借款收到的现金", "发行债券收到的现金", "偿还债务支付的现金", "分配股利支付的现金", "净额"]
                                    if json["debt"]["three_years"].count != 0 {
                                        for i in 0..<5 {
                                            for j in 0..<2 {
                                                if j == 0 {
                                                    cashList.append(cashTitleList[i])
                                                }
                                                else {
                                                    let size = json["debt"]["three_years"].count
                                                    for k in (0..<size).reversed() {
                                                        cashList.append(unitFormat(json["debt"]["three_years"][k][8 + i].double ?? 0).replacingOccurrences(of: "亿", with: ""))
                                                    }
                                                    if size == 1 {
                                                        cashList.append("-")
                                                        cashList.append("-")
                                                    }
                                                    else if size == 2 {
                                                        cashList.append("-")
                                                    }
                                                    
                                                    if json["debt"]["last"].count == 0 {
                                                        cashList.append("-")
                                                    }
                                                    else {
                                                        cashList.append(unitFormat(json["debt"]["last"][8 + i].double ?? 0).replacingOccurrences(of: "亿", with: ""))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.mView?.setCashFlowTable(dataList: cashList, latestDate: latest)
                                    
                                    //MARK: -股权融资情况
                                    var sharingFinancingString = ""
                                    if (json["share_financing_total"]["listed_num"].int ?? 0) != 0 {
                                        sharingFinancingString = "该集团旗下共有\(json["share_financing_total"]["listed_num"].int ?? 0)家上市公司，分别为"
                                        for i in 0..<json["share_financing_total"]["listed"].count {
                                            if i < json["share_financing_total"]["listed"].count - 1 {
                                                sharingFinancingString += "\(json["share_financing_total"]["listed"][i])、"
                                            }
                                            else {
                                                sharingFinancingString += "\(json["share_financing_total"]["listed"][i])。"
                                            }
                                        }
                                        if (json["share_financing_total"]["total"].double ?? 0) != 0 {
                                            sharingFinancingString += "根据公开信息显示，集团旗下上市公司合计通过股票市场融资\(unitFormat((json["share_financing_total"]["total"].double ?? 0) / 10000))亿元。"
                                            for i in 0..<json["share_financing_total"]["detail"].count {
                                                sharingFinancingString += "其中\(json["share_financing_total"]["detail"][i][0].string ?? "-")类型股票募集\(unitFormat((json["share_financing_total"]["detail"][i][1].double ?? 0) / 10000))亿元，"
                                            }
                                            sharingFinancingString += "股票募集资金情况如下表："
                                        }
                                        self.mView?.setEquityFinancingInfo(para: sharingFinancingString)
                                        
                                        //MARK: -股权融资表格
                                        var sharingFinancingList: [String] = []
                                        for i in 0..<json["share_financing_detail"].count {
                                            for j in 0..<json["share_financing_detail"][i]["detail"].count {
                                                sharingFinancingList.append(json["share_financing_detail"][i]["s_name"].string ?? "-")
                                                sharingFinancingList.append(json["share_financing_detail"][i]["detail"][j][1].string ?? "-")
                                                sharingFinancingList.append(json["share_financing_detail"][i]["detail"][j][0].string ?? "-")
                                                sharingFinancingList.append(json["share_financing_detail"][i]["address"].string ?? "-")
                                                sharingFinancingList.append(unitFormat(json["share_financing_detail"][i]["detail"][j][2].double ?? 0))
                                                sharingFinancingList.append(unitFormat(json["share_financing_detail"][i]["detail"][j][3].double ?? 0))
                                                sharingFinancingList.append(unitFormat((json["share_financing_detail"][i]["detail"][j][4].double ?? 0) / 10000))
                                                sharingFinancingList.append(json["share_financing_detail"][i]["lead_underwriter"].string ?? "-")
                                            }
                                        }
                                        self.mView?.setEquityFinancingTable(dataList: sharingFinancingList)
                                    }
                                    else {
                                        sharingFinancingString = "该公司无公开股票融资情况"
                                        self.mView?.setEquityFinancingInfo(para: sharingFinancingString)
                                    }
                                    
                                    //MARK: -资产管理计划情况
                                    var planString = ""
                                    let trustCount = json["trust"]["count"].int ?? 0
                                    let assetCount = json["asset"]["count"].int ?? 0
                                    let insuranceCount = json["insurance"]["count"].int ?? 0
                                    let planCount = trustCount + assetCount + insuranceCount
                                    if planCount == 0 {
                                        planString = "该公司暂无公开资产管理计划"
                                    }
                                    else {
                                        planString = "截至\(dateformatter.string(from: Date()))，根据公开数据及相关大数据显示，\(json["group_name"])及其下属公司作为最终融资方共发行资产管理计划\(planCount)支，"
                                        planString += "涉及金额\(notNull(json["trust"]["total"].string ?? "-"))元，"
                                        planString += "其中信托资管计划\(trustCount)支；保险资管计划\(insuranceCount)支；证券资管计划\(assetCount)支。具体如下表："
                                    }
                                    self.mView?.setAssetManagementPlanInfo(para: planString)
                                    
                                    //MARK: -信托表
                                    var trustList: [String] = []
                                    for i in 0..<json["trust"]["detail"].count {
                                        trustList.append(json["trust"]["detail"][i]["comp_name"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["company_name"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["t_name"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["estab_dt"].string ?? "")
                                        trustList.append(trustScale(json["trust"]["detail"][i]["t_scale"].string ?? ""))
                                        trustList.append(json["trust"]["detail"][i]["t_deadline"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["appli_way"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["in_distr"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["trustee"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["custodian"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["bank"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["t_manag"].string ?? "")
                                        trustList.append(json["trust"]["detail"][i]["f_used"].string ?? "")
                                    }
                                    self.mView?.setTrustTable(dataList: trustList)
                                    
                                    //MARK: -保险表
                                    var insuranceList: [String] = []
                                    for i in 0..<json["insurance"]["detail"].count {
                                        insuranceList.append(json["insurance"]["detail"][i]["comp_name"].string ?? "")
                                        insuranceList.append(json["insurance"]["detail"][i]["insur_ass_name"].string ?? "")
                                        insuranceList.append(json["insurance"]["detail"][i]["reg_number"].string ?? "")
                                        insuranceList.append(json["insurance"]["detail"][i]["ann_date"].string ?? "")
                                    }
                                    self.mView?.setInsuranceTable(dataList: insuranceList)
                                    
                                    //MARK: -证券表
                                    var securityList: [String] = []
                                    for i in 0..<json["asset"]["detail"].count {
                                        securityList.append(json["asset"]["detail"][i]["company_name"].string ?? "")
                                        securityList.append(json["asset"]["detail"][i]["prod_name"].string ?? "")
                                        securityList.append(json["asset"]["detail"][i]["man_name"].string ?? "")
                                        securityList.append(json["asset"]["detail"][i]["coll_name"].string ?? "")
                                    }
                                    self.mView?.setSecurityTable(dataList: securityList)
                                }
                                else if (json["error"].int ?? 1) == 503 {
//                                    mView.removeView()
                                }
                            }
                        case false:
                            print("fail")
                        }
                }
    }
}
