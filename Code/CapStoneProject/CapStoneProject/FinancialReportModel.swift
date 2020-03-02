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
    
    var mView:FinancialReportView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"http://47.92.50.218:8881/api1/financing_index")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
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
                        self.mView?.setShareHolder(company: notNull(json["first_holder_name"].string ?? ""), percent: json["first_holder_rate"].float ?? -1)
                        //MARK: -历史沿革
                        self.mView?.setHistory(paragraph: notNull(json["estab_date"].string ?? ""))
                        //MARK: -高管信息
                        var managersString = ""
                        for i in 0...(json["managers"].count - 1) {
                            if i < (json["managers"].count - 1) {
                                managersString += "\(json["managers"][i]["name"].string ?? "")、"
                            }
                            else {
                                managersString += "\(json["managers"][i]["name"].string ?? "")等"
                            }
                        }
                        self.mView?.setManager(names: managersString)
                        //MARK: -生产经营情况
                        var businessString = ""
                        var max = 0
                        let businessJSON = json["business"]
                        let dataJSON = businessJSON["key_business_1_year"]["data"]
                        if dataJSON.count == 0 || dataJSON[0].count == 0 {
                            businessString = ""
                        }
                        else {
                            businessString = "公司主营业务分为"
                            for i in 0...(dataJSON.count - 1){
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
                            for i in 0...(dataJSON.count - 1) {
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
                            businessString += "\(businessJSON["year"])实现营业额\(unitFormat(String(businessJSON["operate_rev"].double ?? 0)))元人民币，同比"
                            if (businessJSON["operate_rev_YOY"].string ?? "").contains("-") {
                                businessString += "减少\(((businessJSON["operate_rev_YOY"].string ?? "-") as NSString).substring(from: 1))；"
                            }
                            else {
                                businessString += "增加\(businessJSON["operate_rev_YOY"])；"
                            }
                            businessString += "实现了利润总额\(unitFormat(String(businessJSON["profit"].double ?? 0)))元人民币，同比"
                            if (businessJSON["profit_YOY"].string ?? "").contains("-") {
                                businessString += "减少\(((businessJSON["profit_YOY"].string ?? "-") as NSString).substring(from: 1))。"
                            }
                            else {
                                businessString += "增加\(businessJSON["profit_YOY"])。"
                            }
                        }
                        self.mView?.setBusinessInfo(paragraph: businessString)
                        //生产经营情况表格
                        var productList:[[[String: String]]] = []
                        for i in 0...(dataJSON.count - 1) {
                            if dataJSON[i].count != 0 {
                                if notNull(dataJSON[i][1].string ?? "") == "产品" {
                                    var map: [[String: String]] = []
                                    map.append(["name": unitFormat(dataJSON[i][2].string ?? "")])
                                    map.append(["rate": unitFormat(dataJSON[i][4].string ?? "")])
                                    productList.append(map)
                                }
                                else if notNull(dataJSON[i][1].string ?? "") == "地区"{
                                    
                                }
                            }
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
}
