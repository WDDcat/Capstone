//
//  CompanyDetailModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/1.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CompanyDetailModel: CompanyDetailPresent {

    var mView: CompanyDetailView?

    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)financing_index")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        self.mView?.setCompanyName(name: json["name"].string ?? "")
                        self.mView?.setLegalPerson(name: json["legal_name"].string ?? "")
                        self.mView?.setShareHolder(name: json["first_holder_name"].string ?? "")
                        self.mView?.setStarStatus(status: json["flag"].int ?? 0)
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    func postAddCollect(name: String) {
        print("stared company:\"\(name)")
        let param:[String:Any] = ["c_id": remoteGetCompanyId(), "name": name, "record_from": "iOS"]
        Alamofire.request(URL(string :"\(BASEURL)collect_company")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["info"].string ?? "") == "收藏成功" {
                            self.mView?.addSuccess()
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    func postCancelCollect(name: String) {
        print("unstared company:\"\(name)")
        let param:[String:Any] = ["c_id": remoteGetCompanyId(), "name": name, "record_from": "iOS"]
        Alamofire.request(URL(string :"\(BASEURL)cancel_collect")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["info"].string ?? "") == "取消收藏成功" {
                            self.mView?.cancelSuccess()
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
}
