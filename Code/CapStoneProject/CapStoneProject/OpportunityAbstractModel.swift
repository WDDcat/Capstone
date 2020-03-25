//
//  OpportunityAbstractModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/12.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OpportunityAbstractModel: OpportunityAbstractPresenter {
    
    var mView: OpportunityAbstractView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)opportunity_abstract")!, parameters: param, headers: getHeader())
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if json["error"].int == 0 {
                            self.mView?.setCompanyName(name: json["name"].string ?? remoteGetCompanyName())
                            var paragraph = ""
                            for i in 0..<json["abstract_info"].count {
                                paragraph = ""
                                for j in 0..<json["abstract_info"][i]["contents"].count {
                                    if !isNullOrEmpty(notNull(json["abstract_info"][i]["contents"][j].string ?? "")) {
                                        paragraph += json["abstract_info"][i]["contents"][j].string ?? ""
                                        if j < (json["abstract_info"][i]["contents"].count - 1) { paragraph += "\n" }
                                    }
                                }
                                switch json["abstract_info"][i]["first_level_desc"] {
                                case "存量融资机会":
                                    self.mView?.setExistingFinancingChance(para: paragraph)
                                case "增量融资机会":
                                    self.mView?.setAdditionalFinancingChance(para: paragraph)
                                case "期限优化机会":
                                    self.mView?.setCommitmentOptimizationChance(para: paragraph)
                                case "成本优化机会":
                                    self.mView?.setCostOptimizationChance(para: paragraph)
                                case "财报结构优化机会":
                                    self.mView?.setFinancialStructOptimizationChance(para: paragraph)
                                default:
                                    break
                                }
                            }
                        }
                        else {
                            print("error")
                        }
                    }
                case false:
                    print("fail")
                }
        }
    }
}
