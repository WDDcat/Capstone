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
        print(getHeader())
        Alamofire.request(URL(string :"\(BASEURL)show_user_info")!, headers: getHeader())
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
    
    func getFavouriteInfo(page: Int) {
        let param:[String:Any] = ["limit": 10, "page": page]
        Alamofire.request(URL(string :"\(BASEURL)collection_list")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        let result = json["result"]
                        print("\(result.count + (page * 10))/\(json["count"])")
                        
                        let count = result.count + (page * 10)
                        let total = json["count"].int ?? 0
                        if(count == total) {
                            self.mView?.setFooterView(text: "共\(total)个记录")
                        }else {
                            self.mView?.setFooterView(text: "正在加载...")
                        }
                        
                        for i in 0...9 {
                            if i >= result.count { break }
                            var company: [String] = []
                            company.append(result[i][1].string ?? "")//companyName
                            company.append(result[i][4].string ?? "")
                            company.append(result[i][2].string ?? "")//legalPerson
                            company.append(result[i][5].string ?? "")
                            company.append(result[i][0].string ?? "")//cid
                            PersonalCenterCompanyList.append(company)
                        }
                        self.mView?.refreshCompanyList()
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    func getFriendsInfo() {
        self.mView?.setFooterView(text: "")
        self.mView?.refreshFriendsList()
    }

    func getMessageInfo() {
        self.mView?.setFooterView(text: "version:1.36.b20200326")
        self.mView?.refreshMessageList()
    }
    
    func logoutAttempt() {
        Alamofire.request(URL(string :"\(BASEURL)cancel_login")!, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["error"].int ?? -1) == 0 {
                            userDefaults.set("", forKey: "session")
                            userDefaults.set("", forKey: "token_id")
                            
                            userDefaults.set("", forKey: "username")
                            userDefaults.set("", forKey: "password")
                            userDefaults.set(false, forKey: "login_status")
                            self.mView?.logoutSuccess()
                            print("info:\(json["info"])")
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

