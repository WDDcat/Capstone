//
//  HistoryDetailModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/3.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HistoryDetailModel: HistoryDetailPresent {
    
    var mView: HistoryDetailView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)changeinfo")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        for i in 0..<json["changeinfos"].count {
                            historyDateList.append(notNull(json["changeinfos"][i]["time"].string ?? ""))
                            historyTypeList.append(notNull(json["changeinfos"][i]["item"].string ?? ""))
                            historyBeforeList.append(notNull(json["changeinfos"][i]["before"].string ?? ""))
                            historyAfterList.append(notNull(json["changeinfos"][i]["after"].string ?? ""))
                        }
                        self.mView?.initList()
                    }
                case false:
                    print("fail")
                }
        }
    }
}
