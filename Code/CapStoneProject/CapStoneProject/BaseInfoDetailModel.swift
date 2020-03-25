//
//  BaseInfoDetailModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/3.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BaseInfoDetailModel: BaseInfoDetailPresent {
    
    var mView: BaseInfoDetailView?
    
    func getInfo(){
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)baseinfo")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        self.mView?.setCompanyName(name: json["name"].string ?? "")
                        self.mView?.setGroupName(name: json["group_name"].string ?? "")
                        self.mView?.setEstablishDate(date: json["estab_date"].string ?? "")
                        
                        var shareList: [[String]] = []
                        if json["list_info"].count != 0 {
                            for i in 0..<(json["list_info"].count) {
                                var map: [String] = []
                                map.append("股票简称：\(json["list_info"][i]["s_name"])")
                                map.append("股票代码：\(json["list_info"][i]["s_id"])")
                                shareList.append(map)
                            }
                        } else {
                            var map: [String] = []
                            map.append("暂无数据")
                            map.append("")
                            shareList.append(map)
                        }
                        self.mView?.setListedInfo(list: shareList)
                        
                        if (json["money"].double ?? -1) != -1 {
                            self.mView?.setResgisteredCapital(capital: unitFormat(Double(json["money"].int ?? 0) / 10000))
                        } else {
                            self.mView?.setResgisteredCapital(capital: "暂无数据")
                        }
                        
                        self.mView?.setLegalPerson(person: json["legal_name"].string ?? "")
                        self.mView?.setRegisteredAddress(address: json["reg_address"].string ?? "")
                        
                        var businessString = ""
                        if json["main_business"].count != 0 {
                            businessString = "公司主营业务主要分为"
                            for i in 0..<json["main_business"].count {
                                if i < json["main_business"].count {
                                    businessString += "\(json["main_business"][i])、"
                                } else {
                                    businessString += "\(json["main_business"][i])"
                                }
                            }
                            businessString += "等几个板块。"
                        } else {
                            businessString = "暂无数据"
                        }
                        self.mView?.setMainBusiness(paragraph: businessString)
                    }
                case false:
                    print("fail")
                }
        }
    }
}
