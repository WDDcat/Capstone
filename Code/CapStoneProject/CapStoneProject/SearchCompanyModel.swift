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
        let param:[String:Any] = ["keyword": keyword, "limit": 10, "page": page]          //海南航空：10 海南：2230 A:133
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
                            companyNameList.append(result[i][1].string ?? "")
                            addressList.append(result[i][4].string ?? "")
                            legalPersonList.append(result[i][2].string ?? "")
                        }
                        self.mView?.refreshCompanyList()
                    }
                case false:
                    print("fail")
                }
        }
    }
}
