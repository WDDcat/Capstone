//
//  OpportunityDetailModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/15.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OpportunityDetailModel: OpportunityDetailPresenter {
    
    var mView: OpportunityDetailView?
    
    func getInfo() {
        let param:[String:Any] = ["c_id": remoteGetCompanyId(), "first_level_name": remoteGetOpportunityFirstLevel()]
        Alamofire.request(URL(string :"\(BASEURL)business_opportunity")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        if json["error"].int == 0 {
                            for i in 0..<json["opportunity_info"].count {
                                var empty = true
                                for j in 0..<json["opportunity_info"][i]["datas"].count {
                                    if (json["opportunity_info"][i]["datas"][j]["suggest_content"].string ?? "") != "" {
                                        if empty {
                                            empty = false
                                            self.mView?.setTitle(title: json["opportunity_info"][i]["title"].string ?? "")
                                        }
                                        self.mView?.setParagraph(para: json["opportunity_info"][i]["datas"][j]["suggest_content"].string ?? "")
                                    }
                                    if json["opportunity_info"][i]["datas"][j]["table"].count != 0 {
                                        if empty {
                                            empty = false
                                            self.mView?.setTitle(title: json["opportunity_info"][i]["title"].string ?? "")
                                        }
                                        for k in 0..<json["opportunity_info"][i]["datas"][j]["table"].count {
                                            var tableEmpty = true
                                            var dataList: [String] = []
                                            self.mView?.setTableColumn(column: json["opportunity_info"][i]["datas"][j]["table"][k]["tableData"]["row_name"].count)
                                            for n in 0..<json["opportunity_info"][i]["datas"][j]["table"][k]["tableData"]["info"].count {
                                                for l in 0..<json["opportunity_info"][i]["datas"][j]["table"][k]["tableData"]["row_name"].count {
                                                    if (json["opportunity_info"][i]["datas"][j]["table"][k]["tableData"]["info"][n][l].string ?? "") != "" {
                                                        if tableEmpty {
                                                            tableEmpty = false
                                                            self.mView?.setParagraph(para: json["opportunity_info"][i]["datas"][j]["table"][k]["tableName"].string ?? "")
                                                        }
                                                    }
                                                    dataList.append(json["opportunity_info"][i]["datas"][j]["table"][k]["tableData"]["info"][n][l].string ?? "")
                                                }
                                            }
                                            if !tableEmpty {
//                                                self.mView?.setTable(dataList: dataList)
                                            }
                                        }
                                    }
                                }
                                if json["opportunity"][i]["table_list"].count != 0 {
                                    if empty {
                                        empty = false
                                        self.mView?.setTitle(title: json["opportunity_info"][i]["title"].string ?? "")
                                    }
//                                    for j in 0..<json["opportunity_info"][i]["table_list"].count {
//                                        if json["opportunity_info"][i]["table_list"][j]["tableData"]["row_name"].count != 0 {
//                                            self.mView?.setParagraph(para: json["opportunity_info"][i]["table_list"][j]["tableData"].string ?? "")
//                                            for l in 0..<json["opportunity_info"][i]["table_list"][j]["tableData"].count {
//                                                
//                                            }
//                                        }
//                                    }
                                }
                                if !empty {
                                    self.mView?.setPartEnd()
                                }
                            }
                            self.mView?.finishSetting()
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
