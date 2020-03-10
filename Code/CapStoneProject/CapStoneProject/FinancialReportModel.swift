//
//  FinancialReportModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FinancialReportModel: FinancialReportPresent {
    
    var mView: FinancialReportView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)financing_index")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        let businessJSON = json["business"]
                        let dataJSON = businessJSON["key_business_1_year"]["data"]
                        let financialJSON = json["financialstatement"]
                        let creditJSON = json["credit_total"]
                        // MARK: -标题栏
                        self.mView?.setCompanyName(name: notNull(json["name"].string ?? ""))
                        var tags:[String] = []
                        tags.append(json["is_bond"].string ?? "")
                        tags.append(json["is_gov"].string ?? "")
                        tags.append(json["is_listed"].string ?? "")
                        tags.append(json["is_loc"].string ?? "")
                        tags.append(json["is_state_owned"].string ?? "")
                        self.mView?.setTags(tags: tags)
                        //MARK: -公司基本情况
                        self.mView?.setgroupName(name: notNull(json["group_name"].string ?? ""))
                        self.mView?.setLegalPerson(name: notNull(json["legal_name"].string ?? ""))
                        //MARK: -股东信息
                        self.mView?.setShareHolder(company: notNull(json["first_holder_name"].string ?? ""), percent: unitFormat(json["first_holder_rate"].double ?? 0))
                        //MARK: -历史沿革
                        self.mView?.setHistory(paragraph: notNull(json["estab_date"].string ?? ""))
                        //MARK: -高管信息
                        var managersString = ""
                        if json["managers"].count == 0 {
                            managersString = "该公司暂无高管信息"
                        }
                        else {
                            for i in 0..<json["managers"].count {
                                if i < (json["managers"].count - 1) {
                                    managersString += "\(json["managers"][i]["name"].string ?? "")、"
                                }
                                else {
                                    managersString += "\(json["managers"][i]["name"].string ?? "")等"
                                }
                            }
                        }
                        self.mView?.setManager(names: managersString)
                        //MARK: -生产经营情况
                        var businessString = ""
                        var max = 0
                        if dataJSON.count == 0 || dataJSON[0].count == 0 {
                            businessString = ""
                        }
                        else {
                            businessString = "公司主营业务分为"
                            for i in 0..<dataJSON.count{
                                if dataJSON[i].count != 0 {
                                    if i < dataJSON.count - 1 && notNull(dataJSON[i][1].string ?? "") == "产品"{
                                        businessString += "\(notNull(dataJSON[i][2].string ?? ""))、"
                                    }
                                    else if dataJSON.count != 0 && i == dataJSON.count - 1 && notNull(dataJSON[i][1].string ?? "") == "产品"{
                                        businessString += "\(notNull(dataJSON[i][2].string ?? ""))"
                                    }
                                }
                            }
                            businessString += "等几个板块。"
                            //计算较大主营业务
                            for i in 0..<dataJSON.count {
                                if dataJSON[i].count != 0 {
                                    if dataJSON[i][1] == "产品" && !isNullOrEmpty(dataJSON[i][4].string ?? "") {
                                        if Double((dataJSON[max][4].string ?? "0%").replacingOccurrences(of: "%", with: ""))! < Double((dataJSON[i][4].string ?? "0%").replacingOccurrences(of: "%", with: ""))! {
                                            max = i
                                        }
                                    }
                                }
                            }
                            if dataJSON[max].count != 0 {
                                businessString += "主营业务中\(dataJSON[max][2])占较大业务板块，"
                                businessString += "占比\(unitFormat(dataJSON[max][4].string ?? ""))。"
                            }
                        }
                        if isNullOrEmpty(businessJSON["year"].string ?? "") && isNullOrEmpty(businessJSON["operate_rev"].string ?? "") {
                            businessString += "该公司暂无生产经营情况。"
                        }
                        else {
                            businessString += "\(businessJSON["year"])实现营业额\(unitFormat(businessJSON["operate_rev"].double ?? 0))元人民币，同比"
                            if (businessJSON["operate_rev_YOY"].string ?? "").contains("-") {
                                businessString += "减少\(((businessJSON["operate_rev_YOY"].string ?? "-") as NSString).substring(from: 1))；"
                            } else {
                                businessString += "增加\(businessJSON["operate_rev_YOY"])；"
                            }
                            businessString += "实现了利润总额\(unitFormat(businessJSON["profit"].double ?? 0))元人民币，同比"
                            if (businessJSON["profit_YOY"].string ?? "").contains("-") {
                                businessString += "减少\(((businessJSON["profit_YOY"].string ?? "-") as NSString).substring(from: 1))。"
                            } else {
                                businessString += "增加\(businessJSON["profit_YOY"])。"
                            }
                        }
                        self.mView?.setBusinessInfo(paragraph: businessString)
                        //MARK: -生产经营情况表格
                        var productList: [[String]] = []
                        var locationList: [[String]] = []
                        for i in 0..<dataJSON.count {
                            if dataJSON[i].count != 0 {
                                if notNull(dataJSON[i][1].string ?? "") == "产品" {
                                    var map: [String] = []
                                    map.append(unitFormat(dataJSON[i][2].string ?? ""))
                                    map.append(unitFormat(dataJSON[i][4].string ?? ""))
                                    productList.append(map)
                                }
                                else if notNull(dataJSON[i][1].string ?? "") == "地区"{
                                    var map: [String] = []
                                    map.append(unitFormat(dataJSON[i][2].string ?? ""))
                                    map.append(unitFormat(dataJSON[i][4].string ?? ""))
                                    locationList.append(map)
                                }
                            }
                        }
                        self.mView?.setProductList(productList: productList)
                        self.mView?.setLocationList(locationList: locationList)
                        //MARK: -财务情况
                        var financingStateString = ""
                        if(!isNullOrEmpty(financialJSON["year"].string ?? "")) {
                            if (json["is_a_h"].int ?? 0) == 1 {
                                financingStateString += "截止\(financialJSON["year"])，"
                                financingStateString += "公司总资产\(unitFormat(financialJSON["sum_asset"].double ?? 0))元，"
                                financingStateString += "总负债\(unitFormat(financialJSON["sum_debt"].double ?? 0))元，"
                                financingStateString += "所有者权益\(unitFormat(financialJSON["sum_owners_equity"].double ?? 0))元"
                                financingStateString += "资产负债率\(financialJSON["asset_debt_ratio"])。"
                                
                                financingStateString += financialJSON["year"].string ?? ""
                                financingStateString += "实现营业额收入\(unitFormat(financialJSON["operate_rev"].double ?? 0))元，"
                                if (financialJSON["operate_rev_YOY"].string ?? "").contains("-") {
                                    financingStateString += "同比减少\(((financialJSON["operate_rev_YOY"].string ?? "-") as NSString).substring(from: 1))，"
                                } else {
                                    financingStateString += "同比增长\(financialJSON["operate_rev_YOY"])，"
                                }
                                
                                financingStateString += "实现净润\(unitFormat(financialJSON["net_profit"].double ?? 0))元，"
                                if (financialJSON["net_profit_YOY"].string ?? "").contains("-") {
                                    financingStateString += "同比减少\(((financialJSON["net_profit_YOY"].string ?? "-") as NSString).substring(from: 1))。"
                                } else {
                                    financingStateString += "同比增长\(financialJSON["net_profit_YOY"])。"
                                }
                            }
                        } else {
                            financingStateString = "该公司暂无财务情况"
                        }
                        self.mView?.setFinancingInfo(paragraph: financingStateString)
                        //MARK: -融资情况
                        var currencyList: [Credit] = []
                        for i in 0..<creditJSON.count {
                            if(!isNullOrEmpty(creditJSON[i]["currency"].string ?? "")) {
                                if (notNull(creditJSON[i]["currency"].string ?? "") == "人民币元" || notNull(creditJSON[i]["currency"].string ?? "") == "人民币") {
                                    currencyList.append(Credit(priority: 1,
                                                               currency: creditJSON[i]["currency"].string ?? "",
                                                               used: creditJSON[i]["used"].string ?? "",
                                                               amount: creditJSON[i]["amount"].string ?? "",
                                                               unused: creditJSON[i]["unused"].string ?? ""))
                                }
                                else if (notNull(creditJSON[i]["currency"].string ?? "") == "美元") {
                                    currencyList.append(Credit(priority: 2,
                                                               currency: creditJSON[i]["currency"].string ?? "",
                                                               used: creditJSON[i]["used"].string ?? "",
                                                               amount: creditJSON[i]["amount"].string ?? "",
                                                               unused: creditJSON[i]["unused"].string ?? ""))
                                }
                                else if (notNull(creditJSON[i]["currency"].string ?? "") == "欧元") {
                                    currencyList.append(Credit(priority: 3,
                                                               currency: creditJSON[i]["currency"].string ?? "",
                                                               used: creditJSON[i]["used"].string ?? "",
                                                               amount: creditJSON[i]["amount"].string ?? "",
                                                               unused: creditJSON[i]["unused"].string ?? ""))
                                }
                                else if (notNull(creditJSON[i]["currency"].string ?? "") == "日元") {
                                    currencyList.append(Credit(priority: 4,
                                                               currency: creditJSON[i]["currency"].string ?? "",
                                                               used: creditJSON[i]["used"].string ?? "",
                                                               amount: creditJSON[i]["amount"].string ?? "",
                                                               unused: creditJSON[i]["unused"].string ?? ""))
                                }
                                else {
                                    currencyList.append(Credit(priority: 5,
                                                               currency: creditJSON[i]["currency"].string ?? "",
                                                               used: creditJSON[i]["used"].string ?? "",
                                                               amount: creditJSON[i]["amount"].string ?? "",
                                                               unused: creditJSON[i]["unused"].string ?? ""))
                                }
                            }
                        }
//                        NSSortDescriptor(key: <#T##String?#>, ascending: <#T##Bool#>, selector: <#T##Selector?#>)
                        var financingString = ""
                        if creditJSON.count != 0 {
                            financingString = "企业"
                            for credit:Credit in currencyList {
                                financingString += "\(credit.getCurrency())总授信\(unitFormat(credit.getAmont()))亿元，"
                                financingString += "用信\(unitFormat(credit.getUsed()))亿元。"
                            }
                            if json["debt"]["last"].count != 0 {
                                financingString += "根据公开信息显示，该企业存量债券\(unitFormat(json["bond_total"]["total"].double ?? 0))亿元，"
                                financingString += "短期借款\(unitFormat(json["debt"]["last"][1].int ?? 0))元，"
                                financingString += "长期借款\(unitFormat(json["debt"]["last"][4].int ?? 0))元。"
                                
                            }
                        } else {
                            financingString = "该公司暂无公开数据"
                        }
                        self.mView?.setRaisingInfo(paragraph: financingString)
                    }
                case false:
                    print("fail")
                }
        }
    }
}
