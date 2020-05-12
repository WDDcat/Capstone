//
//  CompanyCellModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/26.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol CompanyCellModelDelegate {
    func postAddCollect(c_id: String, name: String, recordName: String, button: UIButton)
    func postCancelCollect(c_id: String, name: String, recordName: String, button: UIButton)
}

class CompanyCellModel: CompanyCellModelDelegate {
    
    func postAddCollect(c_id: String, name: String, recordName: String, button: UIButton) {
        print("stared company:\"\(name)\" with id:(\(c_id))")
        let param:[String:Any] = ["c_id": c_id, "name": name, "record_from": recordName]
        Alamofire.request(URL(string :"\(BASEURL)collect_company")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["info"].string ?? "") == "收藏成功" {
                            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
    
    func postCancelCollect(c_id: String, name: String, recordName: String, button: UIButton) {
        print("unstared company:\"\(name)\" with id:(\(c_id))")
        let param:[String:Any] = ["c_id": c_id, "name": name, "record_from": recordName]
        Alamofire.request(URL(string :"\(BASEURL)cancel_collect")!, method: HTTPMethod.post, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if (json["info"].string ?? "") == "取消收藏成功" {
                            button.setImage(UIImage(systemName: "star"), for: .normal)
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
}
