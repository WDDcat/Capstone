//
//  HolderInfoDetailModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/4.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Charts

class HolderInfoDetailModel: HolderInfoDetailPresent {
    
    var mView: HolderInfoDetailView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)holders")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        
                        self.mView?.setHolderName(name: json["holder"]["name"].string ?? "")
                        
                        var codes:[String] = []
                        if !isNullOrEmpty(json["holder"]["codes"]["a_code"].string ?? "") {
                            codes.append(json["holder"]["codes"]["a_code"].string ?? "") }
                        if !isNullOrEmpty(json["holder"]["codes"]["b_code"].string ?? "") {
                            codes.append(json["holder"]["codes"]["b_code"].string ?? "") }
                        if !isNullOrEmpty(json["holder"]["codes"]["h_code"].string ?? "") {
                            codes.append(json["holder"]["codes"]["h_code"].string ?? "") }
                        if !isNullOrEmpty(json["holder"]["codes"]["n_code"].string ?? "") {
                            codes.append(json["holder"]["codes"]["n_code"].string ?? "") }
                        if !isNullOrEmpty(json["holder"]["codes"]["nas_code"].string ?? "") {
                            codes.append(json["holder"]["codes"]["nas_code"].string ?? "") }
                        if !isNullOrEmpty(json["holder"]["codes"]["x_code"].string ?? "") {
                            codes.append(json["holder"]["codes"]["x_code"].string ?? "") }
                        self.mView?.setStockCode(codes: codes)
                        
                        var others: Double = 0.0
                        var totalSum :Double = 0.0
                        
                        for i in 0..<json["holders"].count {
                            if i < 4 && (json["holders"][i]["rate"].double ?? 0.0) != 0 {
                                if (json["holders"][i]["rate"].double ?? 0.0) > 3.0 {
                                    holderInfoPieChartEntry.append(PieChartDataEntry.init(
                                        value: (json["holders"][i]["rate"].double ?? 0.0),
                                        label: (json["holders"][i]["name"].string ?? "")))
                                }
                                else {
                                    others += json["holders"][i]["rate"].double ?? 0
                                }
                                totalSum += json["holders"][i]["rate"].double ?? 0
                            }
                            else {
                                others += json["holders"][i]["rate"].double ?? 0
                                totalSum += json["holders"][i]["rate"].double ?? 0
                            }
                        }
                        if totalSum < 100.0 {
                            others += 100.0 - totalSum
                            holderInfoPieChartEntry.append(PieChartDataEntry.init(value: others, label: "其他"))
                        }
                        self.mView?.setPieChartData()
                    }
                case false:
                    print("fail")
                }
        }
    }
}
