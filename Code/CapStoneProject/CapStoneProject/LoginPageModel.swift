//
//  LoginPageModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/18.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginPageModel: LoginPagePresenter {
    
    var mView: LoginPageView?
  
    func loginAttempt(id: String, pwd: String) {
        let param:[String:Any] = ["mobile": id, "pwd": pwd]
        Alamofire.request(URL(string :"\(BASEURL)login")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let headerFields = response.response?.allHeaderFields as! [String: String]
                        let cookie = headerFields["Set-Cookie"]
                        let json = JSON(data)
                        if (json["error"].int ?? -1) == 0 {
                            updateSession(newSession: cookie!)
                            print("put session: \(cookie!)")
                            updateToken(newToken: json["token_id"].string!)
                            print("put token: \(json["token_id"].string!)")
                            
                            userDefaults.set(id, forKey: "username")
                            userDefaults.set(pwd, forKey: "password")
                            userDefaults.set(true, forKey: "login_status")
                            self.mView?.loginSuccess()
                        }
                        else if (json["error"].int ?? -1) == 502 {
                            if (json["info"].string ?? "") == "该用户未注册" {
                                self.mView?.setIdPlaceholder(text: "用户不存在")
                                self.mView?.setPasswordPlaceholder(text: "")
                            }
                            else if (json["info"].string ?? "") == "密码错误" {
                                self.mView?.setPasswordPlaceholder(text: "密码错误")
                            }
                            else {
                                self.mView?.setPasswordPlaceholder(text: "用户或密码错误")
//                                self.mView?.setPasswordPlaceholder(text: "")
                            }
                        }
                        
                    }
                case false:
                    print("fail")
                }
        }
    }
}

