//
//  SearchCompanyPresenter.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/28.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchCompanyModel: SearchCompanyPresenter {
    
    var mView:SearchCompanyView?
    
    private var count = 0
    
    func getPerPageInfo(keyword: String, limit:Int, page: Int){
        let param:[String:Any] = ["keyword": "上海奉贤", "limit": 10, "page": page]          //海南航空：10 海南：2230 A:133
        Alamofire.request(URL(string :"http://47.92.50.218:8881/api1/search_company")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        let result = json["result"]
                        print("\(result.count + (page * 10))/\(json["count"])")
                        for i in 0...9 {
                            if i >= result.count { break }
                            cidList.append(result[i][0].string ?? "")
                            companyNameList.append(result[i][1].string ?? "")
                            legalPersonList.append(result[i][2].string ?? "")
                            addressList.append(result[i][4].string ?? "")
                            starList.append(result[i][5].string ?? "")
                        }
                        self.mView?.refreshCompanyList()
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    func postAddCollect(c_id: String, name: String, recordName: String) -> Bool {
        print("stared company:\"\(name)\" with id:(\(c_id))")
        return true
    }
    
    func postCancelCollect(c_id: String, name: String, recordName: String) -> Bool {
        print("unstared company:\"\(name)\" with id:(\(c_id))")
        return true
    }
}
