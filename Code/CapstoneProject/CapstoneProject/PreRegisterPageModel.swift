//
//  PreRegisterModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/24.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class PreRegisterPageModel: PreRegisterPagePresenter {
    
    var mView: PreRegisterPageView?
    
    func getGraphicCode() {
        
    }
    
    func submitRegisteration() {
        
    }
    
    func validateVarificationCode(phone: String, code: String) {
        let param:[String:Any] = ["mobile": phone, "img_code": code]
        Alamofire.request(URL(string :"\(BASEURL)message_code")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        print("info:\(json["info"])")
                        if (json["error"].int ?? -1) == 0 {
                            self.mView?.rightVarificationCode()
                        }
                        else if (json["error"].int ?? -1) == 502 {
                            self.mView?.setVarificationCodePlaceholder(text: "验证码错误")
                        }
                        else if (json["error"].int ?? -1) == 505 {
                            self.mView?.setPhoneNumberPlaceholder(text: "此号码已存在")
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
    
}
