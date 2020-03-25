//
//  RegisterPageModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/22.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegisterPageModel: RegisterPagePresenter {
    
    var mView: RegisterPageView?
    
    func getSavedInfo() {
        Alamofire.request(URL(string :"\(BASEURL)show_user_info")!, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["error"].int ?? -1) == 0 {
                            self.mView?.setRealName(name: json["user_info"]["real_name"].string ?? "")
                            self.mView?.setFinancialFacility(facility: json["user_info"]["institution"].string ?? "")
                            self.mView?.setDepartment(department: json["user_info"]["department"].string ?? "")
                            self.mView?.setPosition(position: json["user_info"]["position"].string ?? "")
                            self.mView?.setDuty(duty: json["user_info"]["responsibility"].string ?? "")
                            self.mView?.setPhoneNumber(num: json["user_info"]["office_phone"].string ?? "")
                            self.mView?.setEmail(email: json["user_info"]["email"].string ?? "")
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
    
    func submitInformation(realName: String, nickName: String, institution: String, department: String, position: String, responsibility: String, phoneNumber: String, email: String, avatar: String, card: String) {
        let param:[String:Any] = ["real_name": realName, "nick_name": nickName, "institution": institution, "department": department, "position": position, "responsibility": responsibility, "office_phone": phoneNumber, "email": email, "avatar": avatar, "card": card]
        Alamofire.request(URL(string :"\(BASEURL)personal_information")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["error"].int ?? -1) == 0 {
                            print("info:\(json["info"])")
                            self.mView?.submitSuccess()
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
