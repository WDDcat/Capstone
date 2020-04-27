//
//  OwnershipStructureModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/4/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OwnershipStructureModel: OwnershipStructurePresent {
    
    var mView: OwnershipStructureView?
    
    var companyName: String = ""
    
    func refreshCompany(c_id: String) {
        let param:[String:Any] = ["c_id": c_id]
        Alamofire.request(URL(string :"\(BASEURL)baseinfo")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        self.companyName = json["name"].string ?? ""
                        self.mView?.setCurrentCompany(name: "  \(json["name"].string ?? "该公司信息尚未完善")  ")
                        self.mView?.refreshList(c_id: c_id)
                    }
                case false:
                    self.mView?.setCurrentCompany(name: "该公司信息尚未完善")
                }
        }
    }
    
    func refreshFatherList(c_id: String) {
        if(c_id != "") {
            var shareholders:[[String]] = []
            var isGroup: [Bool] = [false]
            let param:[String:Any] = ["c_id": c_id]
            Alamofire.request(URL(string :"\(BASEURL)new_firmgraph_holders")!, parameters: param, headers: getHeader())
                .responseJSON { response in
                    switch response.result.isSuccess{
                    case true:
                        if let data = response.result.value {
                            let json = JSON(data)
                            if (json["error"].int ?? 1) == 0 {
                                self.mView?.setGroupCompany(name: "  \(json["group_name"].string ?? "")")
                                if(json["group_name"].string ?? "" == self.companyName && json["holders"].count == 0) {
                                    self.mView?.removeGroup()
                                    shareholders.removeAll()
                                    isGroup.removeAll()
                                }
                                else {
                                    for i in (0..<json["holders"].count) {
                                        var company: [String] = []
                                        company.append(json["holders"][i]["c_id"].string ?? "")
                                        company.append(json["holders"][i]["holder"].string ?? "")
                                        if isNullOrEmpty(json["holders"][i]["rate"].string ?? "") {
                                            company.append("占比：未知")
                                        }
                                        else {
                                            company.append("占比：\(json["holders"][i]["rate"].string ?? "")%")
                                        }
                                        shareholders.append(company)
                                    }
                                }
                                
                                self.mView?.setFatherList(list: shareholders)
                            }
                        }
                    case false:
                        print("fail")
                    }
            }
        }
    }
    
    func refreshChildList(c_id: String) {
        if(c_id != "") {
            var shareholders:[[String]] = []
            let param:[String:Any] = ["c_id": c_id]
            Alamofire.request(URL(string :"\(BASEURL)firmgraph_investments")!, parameters: param, headers: getHeader())
                .responseJSON { response in
                    switch response.result.isSuccess{
                    case true:
                        if let data = response.result.value {
                            let json = JSON(data)
                            if (json["error"].int ?? 1) == 0 {
                                for i in (0..<json["investments"].count) {
                                    var company: [String] = []
                                    company.append(json["investments"][i]["code"].string ?? "")
                                    company.append(json["investments"][i]["name"].string ?? "")
                                    let rate = json["investments"][i]["rate"].double ?? -1
                                    if rate == -1 {
                                        company.append("占比：未知")
                                    }
                                    else {
                                        company.append("占比：\(rate)%")
                                    }
                                    shareholders.append(company)
                                }
                                
                                self.mView?.setChildList(list: shareholders)
                            }
                        }
                    case false:
                        print("fail")
                    }
            }
        }
    }
}
