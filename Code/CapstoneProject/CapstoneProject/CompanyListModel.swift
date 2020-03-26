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

class CompanyListModel: CompanyListPresenter {
    
    var mView: CompanyListView?
    
    private var count = 0
    
    func getPerPageInfo(keyword: String, limit: Int, page: Int){
        let param:[String:Any] = ["keyword": keyword, "limit": limit, "page": page]          //海南航空控股股份有限：10 海南：2230 A:133   "HANG SANG" 北京中外名人 海航集团有限公司
        Alamofire.request(URL(string :"\(BASEURL)search_company")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        let result = json["result"]
                        print("\(result.count + (page * limit))/\(json["count"])")
                        self.mView?.setFooterView(count: result.count + (page * limit), total: json["count"].int ?? 0)
                        for i in 0..<limit {
                            if i >= result.count { break }
                            SearchCompanyCidList.append(result[i][0].string ?? "")
                            SearchCompanyNameList.append(result[i][1].string ?? "")
                            SearchCompanyLegalPersonList.append(result[i][2].string ?? "")
                            SearchCompanyAddressList.append(result[i][4].string ?? "")
                            SearchCompanyStarList.append(result[i][5].int ?? -1)
                        }
                        self.mView?.refreshCompanyList()
                    }
                case false:
                    print("fail")
                }
        }
    }
}
