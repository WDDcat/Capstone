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
        let param:[String:Any] = ["c_id": getCompanyId()]          //海南航空：10 海南：2230 A:133
        Alamofire.request(URL(string :"http://47.92.50.218:8881/api1/financing_index")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                    }
                case false:
                    print("fail")
                }
        }
    }
}
