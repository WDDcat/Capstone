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
    
    private var count = 0
    
    func getInfo(){
        let param:[String:Any] = ["c_id": remoteGetCompanyId()]
        Alamofire.request(URL(string :"\(BASEURL)search_company")!, parameters: param, headers: header)
            .responseJSON { response in
                switch response.result.isSuccess{
                case true:
                    if let data = response.result.value {
                        let json = JSON(data)
                        
                    }
                case false:
                    print("fail")
                }
        }
    }
}
