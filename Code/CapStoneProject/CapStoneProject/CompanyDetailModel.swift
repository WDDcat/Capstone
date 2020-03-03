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
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]          //海南航空：10 海南：2230 A:133
        Alamofire.request(URL(string :"\(BASEURL)financing_index")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        self.mView?.setCompanyName(name: json["name"].string ?? "")
                        self.mView?.setLegalPerson(name: json["legal_name"].string ?? "")
                        self.mView?.setShareHolder(name: json["first_holder_name"].string ?? "")
                    }
                case false:
                    print("fail")
                }
        }
    }
}
