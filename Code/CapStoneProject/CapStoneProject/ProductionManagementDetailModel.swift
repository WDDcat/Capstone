//
//  ProductionManagementDetailModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/6.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProductionManagementDetailModel: ProductionManagementDetailPresent {
    
    var mView: ProductionManagementDetailView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)business")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        let businessJSON = json["key_business_last"]
                        var businessString: String = ""
                        if businessJSON.count == 0 {
                            businessString = "该公司暂无公开主营业务信息"
                        }
                        else {
                            businessString = "公司主营业务主要分为"
                            for i in 0..<businessJSON.count {
                                if (i < businessJSON.count - 1) && ((businessJSON[i][1].string ?? "") == "产品") {
                                    businessString += "\(businessJSON[i][2])、"
                                }
                                else if (i == businessJSON.count - 1) && ((businessJSON[i][1].string ?? "") == "产品") {
                                    businessString += businessJSON[i][2].string ?? ""
                                }
                            }
                            businessString += "等几个板块。"
                            if (json["operate_rev"].int ?? 0) != 0 {
                                businessString += "\(json["year"])年实现营业额\(unitFormat(json["operate_rev"].int ?? 0))元人民币，"
                            }
                            if (json["operate_rev_YOY"].string ?? "") != "" {
                                if (json["operate_rev_YOY"].string ?? "").contains("-") {
                                    businessString += "同比减少\(((json["operate_rev_YOY"].string ?? "-") as NSString).substring(from: 1))；"
                                } else {
                                    businessString += "同比增长\(json["operate_rev_YOY"])；"
                                }
                                businessString += "实现了总利润额\(unitFormat(json["profit"].int ?? 0))元人民币，"
                            }
                            if (json["profit_YOY"].string ?? "") != "" {
                                if (json["profit_YOY"].string ?? "").contains("-") {
                                    businessString += "同比减少\(((json["profit_YOY"].string ?? "-") as NSString).substring(from: 1))"
                                } else {
                                    businessString += "同比增长\(json["profit_YOY"])"
                                }
                            }
                            var max: Int = 0
                            for i in 0..<businessJSON.count {
                                if (businessJSON[i][1].string ?? "") == "产品" && ((businessJSON[i][4].string) ?? "" != "") {
                                    if Double((businessJSON[max][4].string ?? "0%").replacingOccurrences(of: "%", with: ""))! < Double((businessJSON[i][4].string ?? "0%").replacingOccurrences(of: "%", with: ""))! {
                                        max = i
                                    }
                                }
                            }
                            if (businessJSON[max][2].string ?? "") != "" {
                                businessString += "，主营业务中\(businessJSON[max][2])占较大业务板块，"
                                businessString += "占比\(unitFormat(businessJSON[max][4].string ?? ""))"
                            }
                            businessString += "。"
                        }
                        self.mView?.setBusinessInfo(businessInfo: businessString)
                        
                        
                        for i in 0..<json["key_business_3_year"].count {
                            for j in 0..<json["key_business_3_year"][i]["data"].count {
                                if (json["key_business_3_year"][i]["data"][j][1].string ?? "") == "产品" {
                                    for k in 0..<json["key_business_3_year"][i]["data"][j].count {
                                        productionManagementProductList.append((json["key_business_3_year"][i]["data"][j][k]).stringValue)
                                    }
                                }
                                else {
                                    for k in 0..<json["key_business_3_year"][i]["data"][j].count {
                                        productionManagementAreaList.append((json["key_business_3_year"][i]["data"][j][k]).stringValue)
                                    }
                                }
                            }
                        }
                        self.mView?.setProductTable()
                        self.mView?.setAreaTable()
                    }
                case false:
                    print("fail")
                }
        }
    }
}

