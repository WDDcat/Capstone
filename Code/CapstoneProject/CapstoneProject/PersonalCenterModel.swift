//
//  PersonalCenterModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/19.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PersonalCenterModel: PersonalCenterPresenter {
    
    var mView: PersonalCenterView?
  
    func getPersonalInfo() {
        Alamofire.request(URL(string :"\(BASEURL)show_user_info")!, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["error"].int ?? -1) == 0 {
                            self.mView?.setRealName(name: json["user_info"]["real_name"].string ?? "-")
                            self.mView?.setOccupation(occupation: json["user_info"]["responsibility"].string ?? "-")
                            self.mView?.setCompany(company: json["user_info"]["institution"].string ?? "-")
                            self.mView?.setPosition(position: json["user_info"]["position"].string ?? "-")
                        }
                        else {
                            print("info:\(json["info"])")
                        }
                        
                    }
                case false:
                    print("fail")
                }
        }
    }
}

