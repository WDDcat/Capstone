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

class CapitalRaisingInfoDetailModel: CapitalRaisingInfoDetailPresent {
    
    var mView: CapitalRaisingInfoDetailView?
    //MARK: -企业信息
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
                                            creditString += "\(credit.getCurrency())授信总额\(unitFormat(credit.getAmont()))亿元"
                                        }
                                        creditString += "z合作的银行主要情况如下："
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
                                    if (json["bond_total"]["total"].int ?? -1) != -1 {
                                        let dateformatter = DateFormatter()
                                        dateformatter.dateFormat = "YYYY年MM月dd日"// 自定义时间格式
                                        bondString += "\n截至\(dateformatter.string(from: Date()))，集团及其子公司尚处于存续期债券合计为\(unitFormat(json["bond_total"]["total"].int ?? 0))亿元，"
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
                                        bondList.append("-")
                                        bondList.append(unitFormat(json["bond_total"]["avg_deadline"].int ?? 0))
                                        bondList.append(unitFormat(json["bond_total"]["total"].int ?? 0))
                                        bondList.append("-")
                                        self.mView?.setBondTable(dataList: bondList)
                                    }
                                    else {
                                        bondString = "本公司暂无公开债券信息"
                                        self.mView?.setBondCapitalRaisingInfo(para: bondString)
                                    }
                                    
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
