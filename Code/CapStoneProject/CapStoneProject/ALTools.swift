//
//  ALTools.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/2/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire

let BASEURL = "http://47.92.50.218:8881/api1/"

class ALTools: RequestClient {
    var host: String {
        return BASEURL
    }
    
    internal func requestParam<T : TargetType>(_ r: T, Success: @escaping (Any) -> (), Failure: @escaping (Error) -> ()) {
      if r.hud {
          SVProgressHUD.show()
      }
      
      Alamofire.request(URL(string: "\(self.host)\(r.url)")!, method: r.method, parameters: r.param).responseData {
          (response) in
          if let data = response.data, let result =  String(data: data, encoding: .utf8) {
              print(result)
              SVProgressHUD.dismiss()
              Success(data)
          }else {
              SVProgressHUD.showError(withStatus: response.error?.localizedDescription)
              Failure(response.error!)
          }
      }
    }
}
