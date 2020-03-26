//
//  PreRegisterModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/24.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PreRegisterPageModel: PreRegisterPagePresenter {
    
    var mView: PreRegisterPageView?
    
    func getGraphicCode() {
        Alamofire.request(URL(string :"\(BASEURL)img_code")!, headers: getHeader())
            .response { response in
                if let data = response.data {
                    let headerFields = response.response?.allHeaderFields as! [String: String]
                    let cookie = headerFields["Set-Cookie"]
                    updateSession(newSession: cookie!)
                    print("put session: \(cookie!)")
                    let image = UIImage(data: data)
                    self.mView?.setGraphicCode(image: image!)
                }
        }
    }
    
    func submitRegisteration(phone: String, password: String, SMSCode: String) {
        let param:[String:Any] = ["mobile": phone, "pwd": password, "message_code": SMSCode]
        Alamofire.request(URL(string :"\(BASEURL)register")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let headerFields = response.response?.allHeaderFields as! [String: String]
                        let cookie = headerFields["Set-Cookie"]
                        if cookie != nil {
                            updateSession(newSession: cookie!)
                            print("put session: \(cookie!)")
                        }
                        
                        let json = JSON(data)
                        print("info:\(json["info"])")
                        if (json["error"].int ?? -1) == 0 {
                            self.mView?.registerSuccess()
                        }
                        else if (json["error"].int ?? -1) == 502 {
                            self.mView?.setPhoneNumberPlaceholder(text: "手机号，密码或手机验证码错误")
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    func submitSMSCode(phone: String, SMSCode: String) {
        let param:[String:Any] = ["mobile": phone, "message_code": SMSCode]
        Alamofire.request(URL(string :"\(BASEURL)verify_mobile")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let headerFields = response.response?.allHeaderFields as! [String: String]
                        let cookie = headerFields["Set-Cookie"]
                        if cookie != nil {
                            updateSession(newSession: cookie!)
                            print("put session: \(cookie!)")
                        }
                        
                        let json = JSON(data)
                        print("info:\(json["info"])")
                        if (json["error"].int ?? -1) == 0 {
                            self.mView?.rightSMSCode()
                        }
                        else if (json["error"].int ?? -1) == 502 {
                            self.mView?.setPhoneNumberPlaceholder(text: "手机号，密码或手机验证码错误")
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    func submitNewPassword(password: String) {
        let param:[String:Any] = ["new_pwd": password]
        Alamofire.request(URL(string :"\(BASEURL)change_pwd")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let headerFields = response.response?.allHeaderFields as! [String: String]
                        let cookie = headerFields["Set-Cookie"]
                        if cookie != nil {
                            updateSession(newSession: cookie!)
                            print("put session: \(cookie!)")
                        }
                        
                        let json = JSON(data)
                        print("info:\(json["info"])")
                        if (json["error"].int ?? -1) == 0 {
                            self.mView?.resetPasswordSuccess()
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    func validateVarificationCode(phone: String, code: String) {
        let param:[String:Any] = ["mobile": phone, "img_code": code]
        var url = ""
        if remoteGetRegisterFrom() == "forget" {
            url = "\(BASEURL)modify_code"
        }
        else if remoteGetRegisterFrom() == "register" {
            url = "\(BASEURL)message_code"
        }
        
        Alamofire.request(URL(string : url)!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let headerFields = response.response?.allHeaderFields as! [String: String]
                        let cookie = headerFields["Set-Cookie"]
                        if cookie != nil {
                            updateSession(newSession: cookie!)
                            print("put session: \(cookie!)")
                        }
                        
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
