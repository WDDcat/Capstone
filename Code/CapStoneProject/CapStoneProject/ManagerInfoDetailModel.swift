//
//  ManagerInfoModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/4.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ManagerInfoDetailModel: ManagerInfoDetailPresent {
    
    var mView: ManagerInfoDetailView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)managers")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        for i in 0..<json["managers"].count {
                            ManagerInfoNameList.append(json["managers"][i]["name"].string ?? "")
                            ManagerInfoPositionList.append(json["managers"][i]["post"].string ?? "-")
                            ManagerInfoIntroductionList.append(json["managers"][i]["abstract"].string ?? "暂无数据")
                        }
                        self.mView?.initList()
                    }
                case false:
                    print("fail")
                }
        }
    }
}
